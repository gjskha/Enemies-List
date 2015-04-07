package Enemies::Mail;

=head1 NAME

Enemies::Mail - formatting and sending reports on Enemies data.

=head1 SYNOPSIS

my $mail = Enemies::Mail->new;

# and so on and so forth

=head1 DESCRIPTION

inherits from MIME::Entity .

=head1 TODO

See about using Enemies::Web's load_tmpl method for formatting the message. 

=head1 AUTHOR

gjskha AT gmail.com

=cut

use HTML::Template;
use strict;
use warnings;
use base 'MIME::Entity';

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;

    my %fields = (Type => "multipart/mixed");
                    
    my $self = bless $proto->SUPER::new->build(%fields), $class;
}

sub subject {
    my $self = shift;
    if (@_) {   
        $self->{subject} = shift;
        $self->head->add('Subject', $self->{subject});
    } else {
        $self->{subject};
    }
}

sub to {
    my $self = shift;
    if (@_) {   
        $self->{to} = shift;
        $self->head->add('To', $self->{to});
    } else {
        $self->{to};
    }
}

sub from {

    my $self = shift;

    if (@_) {   
        $self->{from} = shift;
        $self->head->add('From', $self->{from});
    } else {
        $self->{from};
    }
}

sub send {
    
    my $self = shift;
    open (M, "|/usr/sbin/sendmail -oi -t");
    $self->print(\*M);
    close (M);
}

sub format {

    my $self = shift;

    my %opts = @_;

    my $template = HTML::Template->new( 
        loop_context_vars => 1, 
        global_vars => 1, 
        die_on_bad_params => 1, 
        filename => $opts{"template"},
    ); 

    $template->param( unpromoted => $opts{"data"} );

    return $template->output;
}

1;
