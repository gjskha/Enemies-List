package Enemies::Status;

=head1 NAME

Enemies::Status - The model for Status objects

=head1 DESCRIPTION

Inherits from Enemies::Model::Local .

=head1 AUTHOR

gjskha AT gmail.com

=cut

use strict;
use warnings 'all';
use base 'Enemies::Model::Local';

__PACKAGE__->set_up_table('status');

1;
