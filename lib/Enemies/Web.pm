package Enemies::Web;

=head1 NAME

Enemies::Web - web interface to the Enemies List.

=head1 SYNOPSIS

# set up the run modes and other initialization

$self->setup;

# browse the Enemies database.

$self->browse;

# edit the Enemies database.

$self->edit;

# review changes to the Enemies app.

$self->log;

# annotate something in the db.

$self->note;

# see all the annotations.

$self->annotations;

# About the app.

$self->about;

# JSON dump.

$self->json;

# wrap up and flush the session

$self->teardown;

=head1 DESCRIPTION

Enemies::Web inherits from CGI::Application, which implements the run and new methods.

=head1 AUTHOR

gjskha AT gmail.com

=cut

use strict;
use warnings;
use base "CGI::Application";
use CGI::Session;
use CGI::Session::Driver::file;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser); 
use Enemies::Conf;
use Enemies::Log;
use Enemies::Snippet;
use Enemies::Note;
use Enemies::List;
use Enemies::Cache;
use Enemies::Disp;
use Data::Dumper;
use DateTime;
use JSON;

sub setup {

    my $self = shift;

    my $q = $self->query();

    my $config = Enemies::Conf->new;

    $self->run_modes( 
        "annotations" => "annotations",
             "browse" => "browse",
              "about" => "about", 
               "json" => "json", 
               "edit" => "edit", 
               "note" => "note",
                "log" => "log", 
    );

    $self->tmpl_path($config->viewdir); 

    # filter template comments
    $self->{filter} = sub { 
        my $t = shift; 
        local $/; 
        return $$t =~ s/\/\*.*\*\///g 
    };

    my $session = CGI::Session->new("driver:file;serializer:default",$q);
    
    my $cookie = $q->cookie( 
        -name   => $session->name,
        -value  => $session->id, 
        -expires => "+1y",
    );

    my $snippet = Enemies::Snippet->new;
    my $list = Enemies::List->new;
    my @list = $list->fetch;

    my %layout_stuff = ( 
        "prog", $q->script_name(), 
        "lastmod", $snippet->last_mod, 
        "lastrun", $snippet->last_run,
        "random", $snippet->random_string,
        "sidebar", \@list,
    );

    $self->{layout_stuff} = \%layout_stuff;

    my %template_stuff = (
        "die_on_bad_params", 0,
        "loop_context_vars", 1,
        "global_vars", 1,
        "filter", $self->{filter},
    );

    $self->{template_stuff} = \%template_stuff;

    $self->header_props( -cookie => $cookie );

    $self->{config} = $config;
    $self->{session} = $session;
    $self->{snippet} = $snippet;
    $self->start_mode("browse");
}

sub teardown { 
    my $self = shift;
    $self->{session}->flush();
}

sub browse {

    my $self = shift;

    my $template = $self->load_tmpl(	    
        "browse.tpl",
        %{$self->{template_stuff}},
    );	

    $template->param(
        title => "Browse The Enemies List",
        %{$self->{layout_stuff}},
    );

    my $q = $self->query();

    if ($q->param("as")) {

        my $as = $q->param("as"); 

        my $handle = Enemies::ASN->retrieve( $as );

        my @allocs = $handle->these_allocs;

        # hacky thing until I figure out the best way to deal with ASes
	# that are not announcing anything anymore
        $template->param( "warning" => "There are no allocations in this AS.")
            if (scalar @allocs == 0);
        
        my %states;
        for (@allocs) {

            $states{$_->prom}++;

            my @cache = Enemies::Cache->search( alloc => $_->alloc );

            if ( defined($cache[0])) {
                $_->{rdns}        = $cache[0]->rdns;
            } else {
                $_->{rdns} = "N/A";
            }

        } 

        if ( exists($states{y}) ) {
            $template->param( 
                p_count => $states{y}, 
            );
        }

        if ( exists($states{n}) ) {
            $template->param( 
                u_count => $states{n}, 
            );
        }
                
        $template->param( 
            content => \@allocs, 
                asn => $handle->asn,
               name => $handle->name,
               disp => ( $handle->disp || "no" ),
        );

    }

    return $template->output;
}

sub edit {

    my $self = shift;
    my $session = $self->{session};

    my $user; 
    my $template = $self->load_tmpl(	    
        "edit.tpl",
        %{$self->{template_stuff}},
    );	

    $template->param(
        title => "Edit The Enemies",
        %{$self->{layout_stuff}},
    );
    
    my @enemies = Enemies::ASN->retrieve_all;

    my $q = $self->query();
    if ($q->param("submit")) {
        my $message = $q->param("message");
        my $edit = $q->param("edit");
 
        if (defined($q->param("user"))) {
            $user = $q->param("user"); 
            # refresh session information if username changes
            $session->param("user", $user);
        } elsif (defined($session->param("user"))) {
            $user = $session->param("user");
        } else {
            $user = "unknown";
        }


        my %old;
        for (@enemies) {
            $old{$_->asn}{asn_id} = $_->asn_id;
            $old{$_->asn}{name} = $_->name;
            $old{$_->asn}{disp} = $_->disp;
        } 

        my %new;
        foreach my $as_data (split(/\n/, $edit)) {

            if ($as_data =~ /\S/) {

                my ($new_name, $new_asn, $new_disp) = split(/\s/, $as_data);

                if (defined($new_name) && defined($new_asn) && $new_asn =~ /^\d+$/) {
                    $new_disp = "paroled" unless defined($new_disp); 
                    $new{$new_asn}{name} = $new_name;
                    $new{$new_asn}{disp} = $new_disp; 
                } else {
                    Enemies::Log->event(
                         "who" => $user, 
                        "what" => "In edit mode, could not make sense of '" . $as_data . "', skipping it.",
                    );
                }
            }
        }
  
        # check for deleted ASNs
        foreach my $k (keys(%old)) {

            # delete records that don't show up in POSTed data anymore
            unless(exists($new{$k})) {
                
                Enemies::Log->event(
                     "who" => $user, 
                    "what" => "Marked $k for deletion.",
                );

                my $asn_to_delete = Enemies::ASN->retrieve($old{$k}{asn_id});

                # First drop the allocs associated with the asn.
                my @allocs_to_delete = $asn_to_delete->these_allocs;
                for (@allocs_to_delete) {
                    $_->delete;
                }

                # Then delete the asn.
                $asn_to_delete->delete;
            }
        } 

        foreach my $k (keys(%new)) {

            # create new allocations.
            unless(exists($old{$k})) {
                Enemies::ASN->create(
                              asn => $k, 
                             name => $new{$k}{name}, 
                    creation_time => DateTime->now(time_zone => 'America/Los_Angeles')->strftime("%Y-%m-%d %H:%M:%S"),
                             disp => $new{$k}{disp}, 
                );

                Enemies::Log->event(
                     "who" => $user, 
                    "what" => "creating new entry for AS$k",
                );
            }

            # check for changed names or dispensations.

            if (exists($old{$k})) {
                unless($new{$k}{name} eq $old{$k}{name}) {
                    #print STDERR "k is $k / " . $old{$k}{name};
                     
                    my $asn_to_change = Enemies::ASN->retrieve($old{$k}{asn_id});
                    $asn_to_change->name( $new{$asn_to_change->asn}{name} );
                    $asn_to_change->update;
    
                    Enemies::Log->event(
                         "who" => $user, 
                        "what" => "Changing the name of $k from " . $old{$k}{name} . " to " . $new{$k}{name},
                    );
                }

                unless($new{$k}{disp} eq $old{$k}{disp}) {
    
                    # update
                    my $asn_to_change = Enemies::ASN->retrieve($old{$k}{asn_id});
                    $asn_to_change->disp( $new{$asn_to_change->asn}{disp} );
                    $asn_to_change->update;
    
                    Enemies::Log->event(
                         "who" => $user, 
                        "what" => "Changing the dispensation of $k from " . $old{$k}{disp} . " to " . $new{$k}{disp},
                    );
    
                }
            }
        }
 
        $self->{snippet}->last_mod(DateTime->now(time_zone => 'America/Los_Angeles')->strftime("%Y-%m-%d %H:%M:%S"));

        $self->header_type("redirect");
        $self->header_props(-url => $q->script_name() . "?rm=log" );

    } else {

        $template->param( enemies => \@enemies );

        # autofill the "who are you" textbox
        if ( $session->param("user")) {
            $template->param(user => $session->param("user"));
        }

        return $template->output;
    }
}

sub log {

    my $self = shift;

    my $template = $self->load_tmpl(	    
        "log.tpl",
        %{$self->{template_stuff}},
    );	

    #my @log_data = Enemies::Log->retrieve_all;
    # working around silly Class::DBI::Lite behavior 
    my @log_data = Enemies::Log->search_where({who => { LIKE => '%'}}, {order_by => "creation_time desc"});

    $template->param(
        title => "Activity Log",
        log => \@log_data,
        %{$self->{layout_stuff}},
    );

    return $template->output;
}

sub note {

    # TODO: add "user" column to note table?
    my $self = shift;
    my $session = $self->{session};

    my $template = $self->load_tmpl(	    
        "note.tpl",
        %{$self->{template_stuff}},
    );	

    my $q = $self->query();
    my $annote = $q->param("annote");

    my $user; #= ($q->param("user") || $session->param("user") || "unknown" );
    if (defined($q->param("user"))) {
        $user = $q->param("user"); 
        # refresh session information if username changes
        $session->param("user", $user);
    } elsif (defined($session->param("user"))) {
        $user = $session->param("user");
    } else {
        $user = "unknown";
    }

    if (defined($annote)) {

        my $note_search_results = Enemies::Note->search(entity => $annote);

        my $note_record = $note_search_results->next;

        if ($note_search_results->count > 0 ) { 
            $template->param(note => $note_record->note);
        } else {
            $template->param(note => "",);

        }

        $template->param(
            title => $annote,
           annote => $annote,
             user => $user,
           %{$self->{layout_stuff}},
        );

        if ($q->param("submit")) {

            if ($note_search_results->count > 0 ) { 
                $note_record->note($q->param("annotation"));
                $note_record->update; 
            } else {
                if (defined($q->param("annotation"))) {
                    Enemies::Note->create(entity => $annote, note => $q->param("annotation"));
                }
            } 

            Enemies::Log->event(
                "who" => $user, 
                "what" => "updated annotation for $annote",
            );

            $self->header_type("redirect");
            $self->header_props(-url => $q->script_name() . "?rm=note&annote=$annote&success=1" );
        } 
    } else {
        die "need to provide an entity as a parameter";
    }

    return $template->output;
}

sub annotations {

    my $self = shift;

    my $template = $self->load_tmpl(	    
        "annotations.tpl",
        %{$self->{template_stuff}},
    );	

    my @all_notes = Enemies::Note->retrieve_all;

    $template->param( 
        notes => \@all_notes,
        title => "Annotations",
        %{$self->{layout_stuff}},
    );

    return $template->output;
}

sub about {

    my $self = shift;

    my $template = $self->load_tmpl(	    
        "about.tpl",
        %{$self->{template_stuff}},
    );	


    my @disp; 
    for (Enemies::Disp->retrieve_all) {
        #print STDERR $_->{meaning}; 
        push(@disp, { rank => $_->{rank}, dispensation => $_->{dispensation}, meaning => $_->{meaning} });       
    }

    $template->param( 
             disp => \@disp,
             title => "About The Enemies List",
        maintainer => $self->{config}->maintainer,
        %{$self->{layout_stuff}},
    );

    return $template->output;
}

sub json {

    my $self = shift;
    my @enemies_list = @{$self->{layout_stuff}->{sidebar}};
    my $struct;

    for (@enemies_list) {
        my @allocs;
    
        if  ( ref $_ eq "Enemies::ASN" ) {

            foreach my $alloc ($_->these_allocs) {
                
                if (ref $alloc eq "Enemies::Alloc") {
                    push(@allocs, {
                        alloc_id => $alloc->alloc_id, 
                            prom => $alloc->prom, 
                           alloc => $alloc->alloc, 
                    }); 
                }      
            }

            push(@{$struct->{enemies}}, { 
                        asn_id => $_->asn_id, 
                          name => $_->name,
                 creation_time => $_->creation_time,
                           asn => $_->asn,
                          disp => $_->disp,
                        allocs => \@allocs,
            });     
        } 
    }

    return encode_json $struct;
}

1; 
