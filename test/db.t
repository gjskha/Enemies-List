use Test::Simple tests => 1;

use File::Basename;
use lib dirname(__FILE__) . "/../lib";
use Enemies::ASN;

my $asn = Enemies::ASN->new();

ok( defined($asn) && ref $asn eq 'Enemies::ASN', 'new() works' );
