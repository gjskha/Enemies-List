use Test::Simple tests => 2;
use File::Basename;
use lib dirname(__FILE__) . "/../lib";
use Enemies::Web;

my $app = Enemies::Web->new();

ok( defined($app) && ref $app eq 'Enemies::Web', 'new() works' );

my $res = $app->browse;

ok( defined($res), "browse() seems to do something" );
