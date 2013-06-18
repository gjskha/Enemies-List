package Enemies::Conf;

use strict;
use base 'Config::Tiny';

sub logfile {
    my $self = shift;
    return $self->{_}->{logfile};
}

sub basedir {
    my $self = shift;
    return $self->{_}->{basedir};
}

sub viewdir {
    my $self = shift;
    return $self->{_}->{viewdir};
}

sub dataset {
    my $self = shift;
    return $self->{_}->{dataset};
}

sub enemies {
    my $self = shift;
    return $self->{_}->{enemies};
}
sub dnsrbls {
    my $self = shift;
    return $self->{_}->{dnsrbls};
}


1;
