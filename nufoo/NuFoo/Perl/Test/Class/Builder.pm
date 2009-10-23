package NuFoo::Perl::Test::Class::Builder;

use CLASS;
use Moose;
use MooseX::Method::Signatures;
use MooseX::Types::Moose qw( :all );
use NuFoo::Core::Types qw(
    PerlPackageName
    PerlPackageList
    PerlMooseAttributeSpec
    PerlMooseAttributeSpecList
);
use Log::Any qw($log);
use File::Spec::Functions qw/catfile/;

extends 'NuFoo::Core::Builder';

with 'NuFoo::Core::Role::TT';

has class => (
    is            => "rw",
    isa           => PerlPackageName,
    required      => 1,
    documentation => qq{The class name.},
);

has uses => (
    is      => "rw",
    isa     => PerlPackageList,
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

method build {
    if ( $self->deep ) {
        my $uses = $self->uses;
        unless ( @$uses ~~ "Test::Deep" ) {
            $self->uses( [ "Test::Deep", @$uses ] );
        }
    }

    if ( $self->use_test ) {
        my $uses = $self->uses;
        my @mods = split /[, ]/, $self->use_test;
        foreach (@mods) { 
            $self->uses( [ "Test::$_", @{$self->uses} ] )
                unless ( @$uses ~~ "Test::Deep" );
        }
    }

    my $file = $self->class2file( $self->class );
    if ( -d catfile( 't', 'lib' ) ) {
        $log->info( "Using local '".catfile('t','lib')."' directory" );
        $file = catfile( 't', 'lib', $file );
    }
    $self->tt_write( $file => "class.pm.tt" );

    if ( $self->t_file ) {
        my $file = $self->t_file_name;
        if ( -d 't' ) {
            $log->info("Using local 't' directory");
            $file = catfile( 't', $file );
        }
        $file .= ".t" unless $file ~~ /\.t$/;
        $self->tt_write( $file => "test.t.tt" );
    }
}

method class2file (Str $name) {
    $name =~ s/::/\//g;
    $name . ".pm";
}

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 NAME

NuFoo::Perl::Test::Class::Builder - Builds Test::Class based tests.

=head1 SYNOPSIS

 $ nufoo Perl.Test.Class --class=CLASS [ATTRIBUTES] 

=head1 DESCRIPTION

Builds L<Test::Class> based tests.

=head1 ATTRIBUTES 

=over 4

=item class

The class name for your new test. Used to build the file name. Will use a local
F<t/lib> if found.

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

L<NuFoo>, L<NuFoo::Core::Builder>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

See L<NuFoo>.

=cut
