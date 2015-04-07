package Enemies::Log;

=head1 NAME

Enemies:Log - The model for Log objects

=head1 SYNOPSIS

# %info is a hash containing who and what key value pairs.

$self->event(%info);

=head1 DESCRIPTION

Inherits from Enemies::Model::Local .

=head1 AUTHOR

gjskha AT gmail.com

=cut


use strict;
use warnings 'all';
use DateTime;
use base 'Enemies::Model::Local';

__PACKAGE__->set_up_table('log');

sub event {

    my $class = shift;
    my $self = bless {}, $class; 
    my %info = @_;

    $self->create( 
                  who => $info{who}, 
                 what => $info{what}, 
        creation_time => DateTime->now(time_zone => 'America/Los_Angeles')->strftime("%Y-%m-%d %H:%M:%S"),
    );

}

1;
