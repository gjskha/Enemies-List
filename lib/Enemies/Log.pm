package Enemies::Log;

use strict;
use Enemies::Conf;
use Enemies::File;

sub event {

    my $class = shift;
    my $self = bless {}, $class; 
    my %info = @_;

    my $config = Enemies::Conf->read("config");
    my $filer = Enemies::File->new;
    
    my $logs = $filer->slurp_json($config->logfile);

    unshift(@{$logs->{log}}, \%info);

    $filer->dump_struct({
        file => $config->logfile, 
      struct => $logs
    });
}

1;
