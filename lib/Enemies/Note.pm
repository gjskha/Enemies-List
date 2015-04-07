package Enemies::Note;

=head1 NAME

Enemies::Note - The model for Note objects

=head1 DESCRIPTION

Inherits from Enemies::Model::Local .

=head1 AUTHOR

gjskha AT gmail.com

=cut

use strict;
use warnings 'all';
use base 'Enemies::Model::Local';

__PACKAGE__->set_up_table('note');

1;
