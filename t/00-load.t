#!perl

use strict;
use warnings;
use FindBin qw/$Bin/;
use lib ("$Bin/../nufoo");

use Test::More tests => 6;

BEGIN {
    use_ok( 'NuFoo' );
    use_ok( 'NuFoo::Cmd' );
    use_ok( 'Log::Any::Adapter::Term' );
    use_ok( 'NuFoo::Builder' );
    
    # These are loaded from ../nufoo
    use_ok( 'NuFoo::NuFoo::Builder::Builder' );
    use_ok( 'NuFoo::Perl::Moose::Class::Builder' );
}

diag( "Testing NuFoo $NuFoo::VERSION, Perl $], $^X" );
