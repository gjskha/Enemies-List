use Test::Simple tests => 4;
use File::Basename;
use lib dirname(__FILE__) . "/../lib";
use Enemies::Snippet;

my $snipper = Enemies::Snippet->new;

ok( $snipper->last_run, "last_run() works" );

ok( $snipper->last_mod, "last_mod() works" );

ok( $snipper->random, "random() works" );

my $random = int(rand(1000000));
$snipper->random($random);
my $return = $snipper->random; 
ok( $return == $random, "random() round trip works" );
