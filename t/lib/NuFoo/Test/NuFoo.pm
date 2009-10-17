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

1;
