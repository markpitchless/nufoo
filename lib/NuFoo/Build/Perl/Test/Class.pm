package NuFoo::Build::Perl::Test::Class;

use CLASS;
use Moose;
use Moose::Autobox;
use MooseX::Method::Signatures;
use MooseX::Types::Moose qw( :all );
use NuFoo::Types qw(
    Dir
    ArrayRefOfStr
    PerlPackageName
    PerlPackageList
);
use Log::Any qw($log);
use File::Spec::Functions qw/catfile/;
use Path::Class qw(dir);

extends 'NuFoo::Builder';

with 'NuFoo::Role::TT';
with 'NuFoo::Role::Perl';

has class => (
    is            => "rw",
    isa           => PerlPackageName,
    required      => 1,
    documentation => qq{The Test::Class subclass name. e.g. Foo::Test.},
);

has uses => (
    is      => "rw",
    isa     => ArrayRefOfStr,
    default => sub { [] },
    documentation => qq{List of packages to use.},
);

has use_test => (
    is      => "rw",
    isa     => Str,
    documentation => qq{Str list seperated by comma or space of Test:: modules to use.},
);

has deep => (
    is      => "rw",
    isa     => "Bool",
    documentation => qq{Use Test::Deep.},
);

has t_file => (
    is      => "rw",
    isa     => "Bool",
    default => 0,
    documentation => qq{Create a normal .t file to run this Test::Class},
);

has t_file_name => (
    is      => "rw",
    isa     => "Str",
    lazy_build => 1,
    documentation => qq{Name for .t file when is using t_file option.},
);

sub _build_t_file_name {
    my $self = shift;
    my $name = lc $self->class;
    $name =~ s/::/-/g;
    return "$name.t";
}

has t_lib_dir => (
    is          => "rw",
    isa         => Dir,
    coerce      => 1,
    lazy_build  => 1,
    documentation => qq{Directory for Test::More lib (.pm) files. Default uses t/lib if found otherwise perl_dir.},
);

method _build_t_lib_dir {
    my $t_lib = dir('t', 'lib');
    unless ( -d dir($self->nufoo->outdir, $t_lib) ) {
        $t_lib = $self->perl_dir;
    }
    $log->info( "Using t_lib_dir '$t_lib' directory" );
    return $t_lib;
}

method build {
    $self->uses->unshift("Test::Deep")
        if $self->deep && !($self->uses ~~ "Test::Deep");

    if ( $self->use_test ) {
        $self->uses->push("Test::$_") foreach split /[, ]/, $self->use_test;
    }

    my $file = $self->perl_class2file( $self->class, dir => $self->t_lib_dir );
    $self->tt_write( $file => "class.pm.tt" );

    if ( $self->t_file ) {
        my $file = $self->perl_t_dir->file( $self->t_file_name . ".t" );
        $self->tt_write( $file => "test.t.tt" );
    }
    else {
        $log->notice("You need to add ".$self->class." to you test runner.");
    }
}

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 NAME

NuFoo::Build::Perl::Test::Class - Builds Test::Class based tests.

=head1 SYNOPSIS

 $ nufoo Perl.Test.Class --class=CLASS [ATTRIBUTES] 

=head1 DESCRIPTION

Builds L<Test::Class> based tests. L</class> gives the name for the new Test,
which will be a sub class of L<Test::Class>. e.g. Foo::Test for testing the Foo
module. This is placed in L</t_lib_dir>, which will be F<t/lib> if exists
otherwise the normal perl_dir (see L<NuFoo::Role::Perl>).

You will then need to add that class to you Test::Class test runner.
Alternatively set the L</t_file> option to create a normal .t file to run
the new test class. This goes in the perl_t_dir (see L<NuFoo::Role::Perl/perl_t_dir>).

=head1 ATTRIBUTES 

=over 4

=item class

The class name for your new test. Used to build the file name. Will use a local
F<t/lib> if found.

=item t_lib_dir

Directory for Test::More lib (.pm) files. Default uses t/lib if found otherwise perl_dir.

=item uses

Package names to use in the test.

=item deep

Use Test::Deep

=item use_test

String of package names (seperated by comma or space) under Test:: to use. E.g.
"Deep,Exception" would "use Test::Deep; use Test::Exception;" in the built
test.

=item t_file

Create a normal .t file to run this Test::Class.

=item t_file_name

Name for .t file when is using t_file option.

=back

=head1 EXAMPLES 

 nufoo Perl.Test.Class --class=NuFoo::Test::Role::TT
 
 nufoo Perl.Test.Class --class My::Foo --use_test Deep,Exception
 
 nufoo Perl.Test.Class --class My::Foo --deep -uses My::Test
 
 nufoo Perl.Test.Class --class My::Foo --deep --t_file
 
 nufoo Perl.Test.Class --class My::Foo --deep --t_file --t_file_name=foo

=head1 SEE ALSO

L<NuFoo>, L<NuFoo::Builder>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

See L<NuFoo>.

=cut
