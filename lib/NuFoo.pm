package NuFoo;

=head1 NAME

NuFoo - Command line boilerplate generator for developers.

=head1 VERSION

Version 0.06

=cut

our $VERSION = '0.06';

use Moose;
use MooseX::Method::Signatures;
use Log::Any qw($log);
use File::Spec::Functions qw( rel2abs abs2rel splitpath splitdir catfile );
use File::Path qw(make_path);
use File::Find;
use Path::Class;
use MooseX::Getopt::Meta::Attribute::Trait;
use NuFoo::Conf;
use NuFoo::Types qw(File Dir FileList);
use Cwd qw(getcwd);

has include_path => (
    is         => 'rw',
    isa        => 'ArrayRef',
    lazy_build => 1,
    auto_deref => 1
);

has config_files => (
    is         => "ro",
    isa        => FileList,
    coerce     => 1,
    predicate  => "has_config_files",
);

method _build_include_path () {
    # Paths to use in ISA must be absolute.
    return [
        rel2abs("nufoo"),
        rel2abs(".nufoo"),
        "$ENV{HOME}/.nufoo",
        '/usr/local/share/nufoo',
    ];
}

has force => (
    traits        => ['Getopt'],
    is            => 'rw',
    isa           => 'Bool',
    required      => 1,
    default       => 0,
    cmd_aliases   => ['f'],
    documentation => qq{Overright existing files} );

has conf => (
    is  => "ro",
    isa => "NuFoo::Conf",
    lazy_build => 1,
);

method _build_conf {
    my %args;
    $args{files} = $self->config_files if $self->has_config_files;
    return NuFoo::Conf->new(%args); 
}

has outdir => (
    is            => "rw",
    isa           => Dir,
    coerce        => 1,
    lazy_build    => 1,
    documentation => qq{Output dir. Default is pwd.},
);

method _build_outdir { getcwd() }

method BUILD {
    my $conf = $self->conf; # Causes load
    use Data::Dumper;
    foreach ( $self->meta->get_all_attributes ) {
        my $name = $_->name;
        next if $name =~ /^_/;
        next if $name eq "conf";
        my $val = $conf->get( "NuFoo.$name" ) || next;
        $_->set_value( $self, $val );
    }
};

method load_builder (Str $name) {
    my $class = $self->builder_name_to_class($name);

    {
        # Builders classes will always have ISA
        no strict 'refs';
        return $class if defined @{"${class}::ISA"};
    }

    local @INC = @INC;
    unshift @INC, $self->include_path;
    (my $path = $class) =~ s!::!/!g;
    $path .= ".pm";
    $log->debug("Loading $name as $class ($path) from local INC=@INC");
    eval "use $class";
    $log->debug("use error: $@");
    if ( my ($path) = $@ =~ m/^Can't locate $path in \@INC/ ) {
        die "Can't locate builder $name ($path) in \@INC";
    }
    $log->debug( "Load error: $@" ) if $@;
    die $@ if $@;
    return $class;
}

sub new_builder {
    my $self = shift;
    my $name = shift || confess "No name";
    my $class = $self->load_builder($name) || return undef;
    my %args  = ref $_[0] ? %{$_[0]} : @_;
    $args{nufoo} = $self;
    return $class->new(%args);
}

method build ( Str $name, HashRef $args? ) {
    my $builder = $self->new_builder( $name, $args );
    $builder->build;
}

method builder_name_to_class($class: Str $name) {
    $name =~ s/\./::/g;
    $name =~ s/\//::/g;
    return "NuFoo::Build::$name";
}

method builder_class_to_name($class: Str $name) {
    $name =~ s/^NuFoo::Build:://;
    $name =~ s/::/\./g;
    return $name;
}

method builder_names {
    local @INC = @INC;
    unshift @INC, $self->include_path;
    my @builder_files;
    foreach my $dir ( @INC ) {
        next unless defined $dir and ! ref $dir;
        $dir = catfile($dir, "NuFoo", "Build");
        $log->debug("Searching: $dir");
        next unless -d $dir;
        find( sub {
            push @builder_files, abs2rel($File::Find::name, $dir) if m/\.pm$/;
        }, $dir );
    }
    return sort map {
        my $path = $_;
        $path =~ s/\.pm$//;
        join ".", splitdir($path);
    } @builder_files;
}

method mkdir (Dir $dir does coerce) {
    $dir = Path::Class::File->new($self->outdir, $dir);
    return 1 if -d "$dir";
    my @created = eval { make_path("$dir") };
    if ($@) {
        (my $err = $@) =~ s/ at .*\.pm line \d+\n?//;
        $log->error("Failed creating '$dir' : $err");
        return 0;
    }
    else {
        foreach (@created) {
            my $log_dir = Path::Class::Dir->new($_)->relative;
            $log->info( "Created directory '$log_dir'");
        }
    }
    return $dir;
}

method write_file (
    File $file does coerce,
    Str|ScalarRef $content,
    Bool :$force?
) {
    $force = $self->force if !defined $force;
    
    # ->mkdir also works relative to $self->dir
    $self->mkdir( $file->dir );

    $file = file($self->outdir, $file);
    my $log_file = $file->relative;

    my $exists = -f "$file" ? 1 : 0;
    if ( $exists && !$force ) {
        $log->warning( "Skipped '$log_file' : Already exists (use -f to over write)" );
        return;
    }
    else {
        my $out = $file->open(">") or do {
            $log->error( "Failed to open '$file' to write : $!" );
            return;
        };
        print $out (ref $content ? $$content : $content);
        $log->info( ($exists ? "Over wrote" : "Created") . " file '$log_file'" );
    }
    return $file;
}

1;
__END__

=head1 SYNOPSIS

This is the internal library for NuFoo, you probably want the command line
interface, L<nufoo>:

 $ nufoo --help
 $ nufoo Perl.Moose.Class --name='My::Foo'

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 include_path

Array of directories to search for builders in. Default is F<nufoo>, F<.nufoo>
in current directory, F<$HOME/.nufoo> and F</usr/local/share/nuff>, in that
order.

=head2 config_files

FileList of config files to load in order.

=head2 force

Bool, default false. Over write existing files.

=head2 conf

Holds the L<NuFoo::Conf> object with our configuration. Default creates a new
L<NuFoo::Conf> object passing L</config_files> to the constructor.

=head2 outdir

Dir. Where the built stuff goes, default is the current working directory.
Builders should generally work relative to this, which the methods here do for
you.

=head1 METHODS

=head2 build

 build( Str $name, HashRef $args? )

Run a builder. Creates a builder via L</new_builder>, with the hash of args
given and then calls build on it. The core entry point to all the NuFoo
building goodness.

=head2 new_builder

 my $builder = $nufoo->new_builder( $name, $args );
 my $builder = $nufoo->new_builder( $name, @args );

Load and construct a builder for the name given, returing the object.
Args can be a hashref or list.

=head2 load_builder

 load_builder( Str $name );

Load the builder given by name, returing the builders class name if loaded.
Returns undef if the builder is not found and throws an error if the builder
fails to load.

Builders are searched for in the normal perl include path as well as the
L<include_path> attrib on the NuFoo object.

=head2 builder_name_to_class

 builder_name_to_class( Str $name );

Return the class name for the builder name given. Builder names can be given
using . or :: or / as a seperator. The name is additionally prefixed with
NuFoo:: to keep them all in a namespace out of the way of the rest of perl.
All Builders are called Builder. This is to make it easy to list all
builders in the include path.
e.g.

 Perl.Moose.Class -> NuFoo::Perl::Moose::Class::Builder
 NuFoo.Builder    -> NuFoo::NuFoo::Builder::Builder
 HTML/Page        -> NuFoo::HTML::Page::Builder

=head2 builder_class_to_name

=head2 builder_names

Return list of availiable builder names.

=head2 write_file

    $self->write_file( $file, $content );
    $self->write_file( $file, \$content );
    $self->write_file( "hello.txt", "Hello World" );
    $self->write_file( ['lib', 'Hello', 'World.pm'], "package Hello::World\n..." );

The core file writing method, builders should put their writes through here
and infact have their own write_file method that proxies here.

File path is relative to L</outdir> and any missing directories in the path are
created. Content can be either a string or a ref to a string. Won't overrite
files unless L</force> in set or a true force arg is explicity passed in.

Logs everything done.

=head2 mkdir(Dir $dir)

Create a directory in the output directory, logging having done so. C<$dir> is
either the string path for the dir or a L<Path::Class::Dir> object. All
intermediate directories are created (think mkdir -p). Does nothing if the
directory already exists. Returns a L<Path::Class::Dir> for the new directory.
Throws an error if the directory fails to create.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.

Please report any bugs or feature requests via the github page at:

L<http://github.com/markpitchless/Log-Any-Adapter-Term>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc NuFoo

The source code is hosted on github:

L<http://github.com/markpitchless/Log-Any-Adapter-Term>


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Mark Pitchless.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut
