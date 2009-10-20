package NuFoo::Test::NuFoo;

use strict;
use warnings;
use FindBin qw/$Bin/;

use base qw(Test::Class);
use Test::More;
use Test::Exception;

use NuFoo;

sub load_builder : Test(4) {
    my $nufoo = NuFoo->new( include_path => ["$Bin/nufoo"] );
    
    ok !$nufoo->load_builder("Not.Found"), "Missing builder not found";
    
    is $nufoo->load_builder("NuFoo.Hello.World"),
        "NuFoo::NuFoo::Hello::World::Builder",
        "NuFoo.Hello.World loaded";

    is $nufoo->load_builder("NuFoo/Hello/World"),
        "NuFoo::NuFoo::Hello::World::Builder",
        "NuFoo/Hello/World loaded";

    is $nufoo->load_builder("NuFoo::Hello::World"),
        "NuFoo::NuFoo::Hello::World::Builder",
        "NuFoo::Hello::World loaded";
}

sub new_builder : Test(6) {
    my $nufoo = NuFoo->new( include_path => ["$Bin/nufoo"] );
    my ($builder);

    $builder = $nufoo->new_builder('NuFoo.Hello.World');
    isa_ok( $builder, "NuFoo::Core::Builder", "No args" );
    isa_ok( $builder, "NuFoo::NuFoo::Hello::World::Builder", "No args" );
    is( $builder->who, "World", "who attrib is default value." );

    $builder = $nufoo->new_builder('NuFoo.Hello.World', { who => "Me" });
    isa_ok( $builder, "NuFoo::Core::Builder", "With args" );
    isa_ok( $builder, "NuFoo::NuFoo::Hello::World::Builder", "With args" );
    is( $builder->who, "Me", "Who attrib set via new call." );
}

1;
