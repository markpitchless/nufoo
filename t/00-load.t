#!perl -T

use Test::More tests => 3;

BEGIN {
    use_ok( 'NuFoo' );
    use_ok( 'NuFoo::Core::Cmd' );
    use_ok( 'NuFoo::Core::Cmd::Logger' );
    use_ok( 'NuFoo::Core::Builder' );
}

diag( "Testing NuFoo $NuFoo::VERSION, Perl $], $^X" );
