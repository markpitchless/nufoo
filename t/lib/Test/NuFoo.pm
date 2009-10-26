package Test::NuFoo;

use strict;
use warnings;
use FindBin qw/$Bin/;

use base qw(Test::Class);
use Test::More;
use Test::Deep;
use Test::Exception;
use Path::Class;

use NuFoo;

sub load_builder : Test(4) {
    my $nufoo = NuFoo->new( include_path => ["$Bin/nufoo"] );
    
    throws_ok { $nufoo->load_builder("Not.Found") } qr/Can't locate builder/,
        "Missing builder not found";
    
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

sub new_builder : Test(9) {
    my $nufoo = NuFoo->new( include_path => ["$Bin/nufoo"] );
    my ($builder);

    $builder = $nufoo->new_builder('NuFoo.Hello.World');
    isa_ok( $builder, "NuFoo::Core::Builder", "No args" );
    isa_ok( $builder, "NuFoo::NuFoo::Hello::World::Builder", "No args" );
    is( $builder->who, "World", "who attrib is default value." );
    isa_ok( $builder->nufoo, "NuFoo", "builder->nufoo" );

    $builder = $nufoo->new_builder('NuFoo.Hello.World', { who => "Me" });
    isa_ok( $builder, "NuFoo::Core::Builder", "With args" );
    isa_ok( $builder, "NuFoo::NuFoo::Hello::World::Builder", "With args" );
    is( $builder->who, "Me", "Who attrib set via new call." );
    isa_ok( $builder->nufoo, "NuFoo", "builder->nufoo" );

    $builder = $nufoo->new_builder( 'NuFoo.Hello.World', who => "You" );
    is $builder->who, "You", "Args passed as list" 
}

sub conf : Test(6) {
    my $self = shift;
    my $nufoo = NuFoo->new( include_path => ["$Bin/nufoo"] );
    ok $nufoo->conf, "New NuFoo has conf";
    isa_ok $nufoo->conf, "NuFoo::Core::Conf";

    my @conf_files = ("$Bin/etc/config");
    $nufoo = NuFoo->new( 
        config_files => [@conf_files],
        include_path => ["$Bin/nufoo"] 
    );
    ok $nufoo->conf, "New NuFoo has conf";
    isa_ok $nufoo->conf, "NuFoo::Core::Conf";
    cmp_deeply $nufoo->conf->files, [file($Bin,"etc","config")] , "Files passed on";
    is $nufoo->conf->get('core.hello'), "world", "Can read core.hello from conf";
}

1;
