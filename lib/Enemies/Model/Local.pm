package Enemies::Model::Local;
  
use strict;
use warnings;
use File::Basename;
use base "Class::DBI::Lite::SQLite";
  
my $database = dirname(__FILE__) . "/../../../data/enemies.db";

__PACKAGE__->connection(
    "DBI:SQLite:$database", "", ""
);
  
1;
