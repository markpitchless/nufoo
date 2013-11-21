use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'NuFoo',
    license             => 'perl',
    dist_author         => q{Mark Pitchless <markpitchless@gmail.com>},
    dist_version_from   => 'lib/NuFoo.pm',
    requires => {
        'Modern::Perl'               => 0,
        'Moose'                      => 0,
        'Moose::Autobox'             => 0,
        'MooseX::Types'              => 0,
        'MooseX::Getopt'             => 0,
        'MooseX::Getopt::Usage'      => 0.16,
        'MooseX::Method::Signatures' => 0,
        'MooseX::StrictConstructor'  => 0,
        'MooseX::Types::Path::Class' => 0,
        'MooseX::Declare'            => 0,
        'CLASS'                      => 0,
        'File::Spec'                 => 0,
        'File::Path'                 => 0,
        'File::Find'                 => 0,
        'File::chmod'                => 0,
        'Template'                   => 0,
        'Log::Any'                   => 0.06,
        'Log::Any::Adapter'          => 0.02,
        'Term::ANSIColor'            => 0,
        'Module::Starter'            => 0,
        'Email::Valid'               => 0,
        'Path::Class'                => 0,
        'Config::IniFiles'           => 0,
        'Try::Tiny'                  => 0,
    },
    build_requires => {
        'Test::More'   => 0,
        'Test::Class'  => 0,
        'Test::Output' => 0.16,
    },
    add_to_cleanup      => [ 'NuFoo-*' ],
    create_makefile_pl => 'traditional',
);

# NuFoo builders use template files (*.tt) from within lib
$builder->add_build_element('tt');

$builder->create_build_script();
