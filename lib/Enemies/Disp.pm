package Enemies::Disp;

=head1 NAME

Enemies::Disp - The model for Dispensations

=head1 DESCRIPTION

Inherits from Enemies::Model::Local .

=head1 AUTHOR

gjskha AT gmail.com

=cut

use strict;
use warnings 'all';
use base 'Enemies::Model::Local';

__PACKAGE__->set_up_table('disp');

1;
