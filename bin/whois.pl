#!/usr/bin/perl -w

=head1 NAME

whois.pl - fetches CIDR ranges associated with each ASN being watched in the Enemies List

=head1 DESCRIPTION

This should be run before host.pl.

=head1 AUTHOR

gjskha AT gmail.com

=cut

use strict;
use File::Basename;
use lib dirname(__FILE__) . "/../lib";
use Enemies::Conf;
use Enemies::Log;
use Enemies::Mail;
use Enemies::Alloc;
use Enemies::ASN;
use Enemies::Note;
use Enemies::List;
use Enemies::Snippet;
use Enemies::Cache;
use Net::DNS;
use DateTime;
use Data::Dumper;

my $config = Enemies::Conf->new;
my $resolver = Net::DNS::Resolver->new;
my $cidr_count = 0;

foreach my $a (Enemies::List->new->fetch()) {
    my $asn = $a->asn;
    my @allocs;

    eval {
        
        Enemies::ASN->do_transaction( sub {

            my $asn_handle = Enemies::ASN->retrieve( $a->asn_id );

            # TODO: insurance against network problem. 
            # this can be redone as a trigger
            my @alloc = $asn_handle->these_allocs;
            foreach my $old_alloc ( @alloc ) {
                $old_alloc->delete;
            }
    
            grep {  
                if ( /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d\/\d\d?/ ) {
                    $cidr_count++;
                    my $alloc = $&;

		    # I am taking for granted that the allocation's final octet
		    # is a '0', and that the allocation is greater than a /30,
		    # which I think are reasonable assumptions in this context.
                    my $test_ip = reverse(substr(reverse($alloc), 4)) . "4";

                    my $lookup_test_ip = "4." . join(".", reverse(split(/\./, reverse(substr(reverse($alloc), 4))))) . ".zen.spamhaus.org";
                    
                    my $query = $resolver->search($lookup_test_ip);

                    my $status;
                    if ($query) {
                        $status = "y";
                    } else {
                        $status = "n";
                    }

                    Enemies::Cache->create(
                        alloc => $alloc,
                           ip => $test_ip,
                         rdns => "--",
                         addr => "--",                 
                    );

                    Enemies::Alloc->create(
                      asn_id => $a->asn_id,
                       alloc => $alloc,
                        prom => $status,
                    );
                }
            } `whois -h whois.cymru.com dump as$asn`;
        });
    };
      
    if( $@ ) {
        Enemies::Log->event(
            "who" => $ENV{USER}, 
           "what" => "ERROR: problem updating $asn: $@"
        );
    } 
}

# set the values for various statuses used in the web app.
my $snippet = Enemies::Snippet->new;
$snippet->random_string(int(rand(1000000)));
$snippet->last_run(DateTime->now(time_zone => 'America/Los_Angeles')->strftime("%Y-%m-%d %H:%M:%S"));

# send an email with the findings 
my $plain;
my @unpromoted;
for (Enemies::Alloc->search_where( prom => "n" )) {

    my $note_search = Enemies::Note->search( entity => $_->alloc );

    my $annotation;
    if ($note_search->count > 0 ) { 
        $annotation = $note_search->next->note;
    }
 
    push(@unpromoted, { 
          cidr => $_->alloc, 
          name => $_->the_asn->name,
          disp => $_->the_asn->disp,
          note => $annotation,
        number => $_->the_asn->asn, 
    });

    $plain .= $_->alloc . "\n";
}

my $msg = Enemies::Mail->new();

my $date = DateTime->now->dmy;
$msg->to($config->to);
$msg->subject("Actionable ranges on $date");
$msg->from($config->from);

my $message = $msg->format(
    template => $config->viewdir . "/actionable.tpl",
        data => \@unpromoted,
);

$msg->attach( 
        Data => $message,
        Type => "text/html",
    Encoding => "base64"
);

$msg->attach( 
        Data => $plain,
        Type => "text/plain", 
    Filename => "plain.txt",
);

$msg->send();

# log this run
Enemies::Log->event(
    "who" => $ENV{USER}, 
   "what" => basename($0) . " processed $cidr_count CIDR ranges.",
);
