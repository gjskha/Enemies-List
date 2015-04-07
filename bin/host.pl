#!/usr/bin/perl 

=head1 NAME

host.pl - augments records with up-to-date rDNS results

=head1 DESCRIPTION

Uses Net::DNS::Async to quickly give better rdns records. It is probably best
to run this after whois.pl!

=head1 AUTHOR

gjskha AT gmail.com

=cut

use strict;
use File::Basename;
use lib dirname(__FILE__) . "/../lib";
use Enemies::Log;
use Enemies::Cache;
use Enemies::Snippet;
use Net::DNS::Async;

my @cache;
my %results;

eval { 
    @cache = Enemies::Cache->retrieve_all;
};


if ($@) {
    Enemies::Log->event(
         "who" => $ENV{USER}, 
        "what" => "ERROR: $0 could not fetch cache: $@"
    );
}

my $r = new Net::DNS::Async( 
    QueueSize => 512, 
    Retries => 4, 
    Timeout => 4,
);

for (@cache) {
    my $reverse =  join(".", reverse(split(/\./, $_->ip))) . '.in-addr.arpa';
    $r->add(\&callback, $reverse, 'PTR');
}

$r->await();

my $what = basename($0);
$what .= " processed $#cache Cache records ";
$what .= "(" . $results{fail} . " failed updates)" 
    if $results{fail};

Enemies::Log->event(
     "who" => $ENV{USER},
    "what" => $what,
);

my $snippet = Enemies::Snippet->new;
$snippet->last_mod(DateTime->now(time_zone => 'America/Los_Angeles')->strftime("%Y-%m-%d %H:%M:%S"));

sub callback {
    my $response = shift;
    return unless defined $response;

    # figure out what IP this corresponds to in the parent process.  Since we
    # are in a child process, we have to figure it out from the DNS response.
    my @octets = split(/\./, @{$response->{question}}[0]->{qname});
    my $ip = $octets[3] . "." . $octets[2] . "." . $octets[1] . "." . $octets[0];
    my $index = $octets[1];

    # parse the rDNS result.
    my $name;
    if ($response->{header}->{rcode} ne "NOERROR") {
        $name = $response->{header}->{rcode}; 
    } else { 
        foreach my $rr ($response->answer) {
            next unless $rr->type eq "PTR";
            $name = $rr->ptrdname;
        }
    }

    my $handle; 
    eval {
        $handle = Enemies::Cache->search( ip => $ip );
        my $record = $handle->next;
        $record->rdns($name);
        $record->update;
    };

    if ($@) {
        $results{fail}++;
    } else {
        $results{success}++;
    }
}
