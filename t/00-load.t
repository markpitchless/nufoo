#!perl -T

use Test::More tests => 2;

BEGIN {
    use_ok( 'NuFoo' );
    use_ok( 'NuFoo::Cmd' );
}

diag( "Testing NuFoo $NuFoo::VERSION, Perl $], $^X" );
