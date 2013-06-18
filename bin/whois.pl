#!/usr/bin/perl -w

use strict;
use lib 'lib';
use Enemies::File;
use Enemies::Conf;
use Enemies::Log;
use Net::DNS;

my $rslvr = Net::DNS::Resolver->new;
my $config = Enemies::Conf->read('config');

my $filer = Enemies::File->new;
my $enemies = $filer->slurp_json($config->enemies);
 
my $structure;

foreach my $as_data (@{$enemies->{enemies}}) {

    my @allocs;
    use Data::Dumper; print Dumper $config;
    grep {  
        if ( /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d\/\d\d?/ ) {

            my $alloc = $&;
            my $tester = join(".", reverse(split(/\./, reverse(substr(reverse($alloc), 3)))));
            my $status = "unfiltered";

            foreach my $bl (split(",", $config->dnsrbls)) {

                my $query = $rslvr->search($tester . "." . $bl );

                $status = "filtered" && last if $query;

            }
 
            push(@allocs, { 
                "alloc" => $alloc, 
               "status" => $status, 
            });
        }

    } `whois -h whois.cymru.com dump as$as_data->{asn}`;
          
    push(@{$structure->{enemies}}, { 
        "name" => $as_data->{name}, 
         "asn" => $as_data->{asn}, 
        "disp" => $as_data->{disp}, 
      "allocs" => \@allocs,
    }); 
     
}

$structure->{last_mod} = `date`;
$enemies->{random} = int(rand(1000000));

$filer->dump_struct({ 
    "file" => $config->dataset, 
  "struct" => $structure,
});

$filer->dump_struct({ 
    "file" => $config->enemies, 
  "struct" => $enemies,
});

Enemies::Log->event(
    "who" => "cron", 
   "when" => `date`,
   "what" => "daily whois check"
);
