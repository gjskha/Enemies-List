package Enemies;

use strict;
use base "CGI::Application";
use HTML::Template;
use CGI::Application;
use CGI::Session;
use CGI::Session::Driver::file;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser); 
use Enemies::File;
use Enemies::Conf;
use Enemies::Utils;
use Enemies::Log;

sub setup {

    my $self = shift;

    my $q = $self->query();

    my $config = Enemies::Conf->read( "config" );

    $self->run_modes( 
        "browse" => "browse",
          "edit" => "edit", 
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

    my $utils = Enemies::Utils->new;

    my %layout_stuff = ( 
        "prog", $q->script_name(), 
        "lastmod", $utils->lastrun($config->enemies), 
        "lastrun", $utils->lastrun($config->dataset),
        "sidebar", $utils->sidebar($config->enemies),
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

    $self->{filer} = Enemies::File->new;
    $self->{config} = $config;
    $self->{session} = $session;

    $self->start_mode("browse");
}

sub teardown { 
    my $self = shift;
    $self->{session}->flush();
}

sub browse {

    my $self = shift;
    my $config = $self->{config};
    my $filer = $self->{filer};

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

        my $as_data = $filer->slurp_json($config->dataset);

        $template->param( "random" => $as_data->{random} );

        foreach my $pit (@{$as_data->{enemies}}) {

            if ($pit->{asn} eq $as) {

                my %states;

		# hacky thing until I figure out the best way to deal with ASes
		# that are not announcing anything anymore
                $template->param( "warning" => "There are no allocations in this AS.")            
                    if (scalar @{$pit->{allocs}} == 0);
    
                foreach my $alloc (@{$pit->{allocs}}) { $states{$alloc->{status}}++ };
                 
                if ( $states{filtered} ) {
                    $template->param( 
                        p_count => $states{filtered}, 
                    );
                }
                if ( $states{unfiltered} ) {
                    $template->param( 
                        u_count => $states{unfiltered}, 
                    );
                }
                
                $template->param( 
                    content => $pit->{allocs}, 
                        asn => $pit->{asn},
                       name => $pit->{name},
                       disp => ($pit->{disp} || "paroled"),
                );

                last;
            }
        }
    }
    
    return $template->output;
}

sub edit {

    my $self = shift;
    my $config = $self->{config};
    my $session = $self->{session};
    my $filer = $self->{filer};

    my $template = $self->load_tmpl(	    
        "edit.tpl",
        %{$self->{template_stuff}},
    );	

    $template->param(
        title => "Edit The Enemies List",
        %{$self->{layout_stuff}},
    );
    
    my $q = $self->query();
    if ($q->param("submit")) {
        my $message = $q->param("message");
        my $edit = $q->param("edit"); 
        my $user = $q->param("user"); 
   
        # refresh session information if username changes
        $session->param("user", $user);

        # process the edits and save the results. 
        my $new_struct;

        foreach my $as_data (split(/\n/, $edit)) {

            if ($as_data =~ /\S/) {

                my ($name, $num, $disp) = split(/\s/, $as_data);

                push(@{$new_struct->{enemies}}, {
                    "name" => $name, 
                     "asn" => $num, 
                    "disp" => $disp,
                });
            }
        }
      
        $new_struct->{last_mod} = `date`;
  
        $filer->dump_struct({ 
            file => $config->enemies, 
          struct => $new_struct
        });

        Enemies::Log->event(
            "who" => $user, 
           "when" => `date`,
           "what" => $message,
        );
      
        $self->header_type("redirect");
        $self->header_props(-url => $q->script_name() . "?rm=log" );

    } else {
        my $enemies = $filer->slurp_json($config->enemies);
        $template->param( enemies => $enemies->{enemies} );

        # autofill the "who are you" textbox
        if ( $session->param("user")) {
            $template->param(user => $session->param("user"));
        }

        return $template->output;
    }
}

sub log {
    my $self = shift;
    my $config = $self->{config};
    my $filer = $self->{filer};

    my $template = $self->load_tmpl(	    
        "log.tpl",
        %{$self->{template_stuff}},
    );	

    my $log_data = $filer->slurp_json($config->logfile);

    $template->param(
        title => "Activity Log",
        log => $log_data->{log},
        %{$self->{layout_stuff}},
    );

    return $template->output;
}

1; 
