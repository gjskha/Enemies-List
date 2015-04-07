package Enemies::List;

=head1 NAME

Enemies::List - routines for acting on all ASNs in the database.

=head1 SYNOPSIS

my $list = Enemies::List->new;

my @all = $list->fetch;

my @asn = $list->asn;

# and so on and so forth

=head1 AUTHOR

gjskha AT gmail.com

=cut

use strict;
use warnings;
use Enemies::ASN;

sub new {
    my $class = shift;
    my $self = bless {}, $class; 
    return $self;
}

sub fetch {
    my $self = shift;

    my @list = Enemies::ASN->retrieve_all;
    $self->{list} = \@list;
    
    return @list;
}

sub asn {

    my $self = shift;

    my @asn;

    for (@{$self->{list}}) {
        push(@asn, $_->asn);
    }

    return @asn;
}

sub creation_time {

    my $self = shift;

    my @ct;
    for (@{$self->{list}}) {
        push(@ct, $_->creation_time);
    }
   
    return @ct;

}


sub name {

    my $self = shift;

    my @name;
    for (@{$self->{list}}) {
        push(@name, $_->name);
    }
   
    return @name;

}

1;
