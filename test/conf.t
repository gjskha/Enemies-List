use Test::Simple tests => 2;
use File::Basename;
use lib dirname(__FILE__) . "/../lib";
use Enemies::Conf;

my $c = Enemies::Conf->new;

ok( ref $c eq "Enemies::Conf", "new() works" );

my $config1 = basename(dirname(__FILE__) . "/../config");

my $config2 = basename($c->basedir . "config" );

ok( $config1 eq $config2, "'$config1' equivalent to '$config2', looking up a parameter worked");
