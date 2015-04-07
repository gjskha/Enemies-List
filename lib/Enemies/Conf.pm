package Enemies::Conf;

=head1 NAME

Enemies::Conf - handles configuration for the Enemies app.

=head1 SYNOPSIS

# reads in configuration file (json format)

my $conf = Enemies::Conf->new;

# get various values 

my $basedir = $conf->basedir;

my $viewdir = $conf->viewdir;

my $database = $conf->database;

# stuff for mailing out reports

my $to = $conf->to;

my $from = $conf->from;

=head1 AUTHOR

gjskha AT gmail.com

=cut

use warnings;
use strict;
use JSON;
use File::Basename;

sub new {
    my $class = shift;
    my $self = bless {}, $class; 

    my $config_file = dirname(__FILE__) . "/../../config";

    open(CONFIG_FILE, $config_file) || die "Can't find config file : $!";
    my $json = do { local $/; <CONFIG_FILE> };
    close(CONFIG_FILE);

    my $options = decode_json($json);
    $self->{options} = $options;

    return $self;
}

sub basedir {
    my $self = shift;
    return $self->{options}->{basedir};
}

sub viewdir {
    my $self = shift;
    return $self->{options}->{viewdir};
}

sub database {
    my $self = shift;
    return $self->{options}->{database};
}

sub to {
    my $self = shift;
    return $self->{options}->{to};
}

sub from {
    my $self = shift;
    return $self->{options}->{from};
}

sub maintainer {
    my $self = shift;
    return $self->{options}->{maintainer};
}

1;
