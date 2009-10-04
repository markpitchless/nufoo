use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'NuFoo',
    license             => 'perl',
    dist_author         => q{Mark Pitchless <markpitchless@gmail.com>},
    dist_version_from   => 'lib/NuFoo.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'NuFoo-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
