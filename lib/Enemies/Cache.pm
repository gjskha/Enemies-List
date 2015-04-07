package Enemies::Cache;
  
use strict;
use warnings 'all';
use base 'Enemies::Model::Local';

=head1 NAME

Enemies::Cache - The model for Cache objects

=head1 DESCRIPTION

Inherits from Enemies::Model::Local .

=head1 AUTHOR

gjskha AT gmail.com

=cut

__PACKAGE__->set_up_table('cache');
  
1;
