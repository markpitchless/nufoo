package NuFoo::Test::Builder;

use strict;
use warnings;
use FindBin qw/$Bin/;

use base qw(Test::Class);
use Test::More;
use Test::Exception;
use File::Spec::Functions qw/abs2rel/;

use NuFoo;

sub construct : Test(2) {
    my $nufoo = NuFoo->new( include_path => ["$Bin/nufoo"] );
    my $class = $nufoo->load_builder("NuFoo.Hello.World");
    my $builder;
    lives_ok { $builder = $class->new() }
        "Can construct loaded builder NuFoo.Hello.World";
    isa_ok $builder, "NuFoo::Builder";
}

sub home_dir : Test(2) {
    # Load from a absolute include path
    my $nufoo   = NuFoo->new( include_path => ["$Bin/nufoo"] );
    my $builder = $nufoo->load_builder("NuFoo.Hello.World")->new();
    is $builder->home_dir, "$Bin/nufoo/NuFoo/NuFoo/Hello/World",
        "home_dir - absolute";
    
    # Load from a relative include path
    my $nufoo_rel = NuFoo->new( include_path => [abs2rel("$Bin/nufoo")] );
    $builder      = $nufoo_rel->load_builder("NuFoo.Hello.World2")->new();
    is $builder->home_dir, "$Bin/nufoo/NuFoo/NuFoo/Hello/World2",
        "home_dir - relative";
}

1;
