#!perl

use strict;
use warnings;
use FindBin qw/$Bin/;
use lib ("$Bin/../lib");

use Test::More tests => 30;

BEGIN {
    use_ok( 'NuFoo' );
    use_ok( 'NuFoo::Cmd' );
    use_ok( 'NuFoo::Builder' );
    use_ok( 'NuFoo::Conf' );
    use_ok( 'NuFoo::Types' );

    use_ok( 'NuFoo::Role::Authorship' );
    use_ok( 'NuFoo::Role::GetoptUsage' );
    use_ok( 'NuFoo::Role::TT' );
    use_ok( 'NuFoo::Role::HTML' );
    use_ok( 'NuFoo::Role::JS' );
    use_ok( 'NuFoo::Role::Licensing' );
    use_ok( 'NuFoo::Role::Perl' );
    use_ok( 'NuFoo::Role::Perl::Moose::Thing' );
    
    use_ok( 'NuFoo::Build::NuFoo::Builder' );
    use_ok( 'NuFoo::Build::Perl::Class::Plain' );
    use_ok( 'NuFoo::Build::Perl::Getopt::Long' );
    use_ok( 'NuFoo::Build::Perl::Module::Starter' );
    use_ok( 'NuFoo::Build::Perl::Moose::Class' );
    use_ok( 'NuFoo::Build::Perl::Moose::Role' );
    use_ok( 'NuFoo::Build::Perl::MooseX::Types' );
    use_ok( 'NuFoo::Build::Perl::Package' );
    use_ok( 'NuFoo::Build::Perl::Test::Class' );
    use_ok( 'NuFoo::Build::Perl::Test::More' );
    use_ok( 'NuFoo::Build::HTML::Page' );
    use_ok( 'NuFoo::Build::ExtJS::Component' );
    use_ok( 'NuFoo::Build::ExtJS::Preconf::Application' );
    use_ok( 'NuFoo::Build::ExtJS::TabPanel' );
    use_ok( 'NuFoo::Build::ExtJS::Viewport' );
    use_ok( 'NuFoo::Build::ExtJS::grid::GridPanel' );
    use_ok( 'NuFoo::Build::ExtJS::tree::TreePanel' );
}

diag( "Testing NuFoo $NuFoo::VERSION, Perl $], $^X" );
