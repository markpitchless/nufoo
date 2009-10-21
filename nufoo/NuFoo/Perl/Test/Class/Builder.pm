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
        $_ = "Test::$_" foreach @mods;
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
    my $out  = $self->tt_process( "class.pm.tt" );
    $self->write_file( $file, \$out );
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

=back

=head1 EXAMPLES 

 nufoo Perl.Test.Class --class=NuFoo::Test::Role::TT

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
