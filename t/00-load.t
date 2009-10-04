#!perl -T

use Test::More tests => 3;

BEGIN {
    use_ok( 'NuFoo' );
    use_ok( 'NuFoo::Cmd' );
    use_ok( 'NuFoo::Builder' );
}

diag( "Testing NuFoo $NuFoo::VERSION, Perl $], $^X" );
