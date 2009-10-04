#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'NuFoo' );
}

diag( "Testing NuFoo $NuFoo::VERSION, Perl $], $^X" );
