package NuFoo::Perl::Test::More::Builder;

=head1 NAME

NuFoo::Perl::Test::More::Builder - Builds Test::More .t files.

=cut

use CLASS;
use Moose;
use Moose::Autobox;
use MooseX::Method::Signatures;
use MooseX::Types::Moose qw( :all );
use NuFoo::Core::Types qw( ArrayRefOfStr PerlPackageList );
use Log::Any qw($log);
use File::Spec::Functions qw/catfile/;

extends 'NuFoo::Core::Builder';

with 'NuFoo::Core::Role::TT';
with 'NuFoo::Role::Perl';

has name => (
    is       => "rw",
    isa      => Str,
    required => 1,
    documentation => qq{The test name. Used for filename.},
);

has uses => (
    is      => "rw",
    isa     => ArrayRefOfStr,
    default => sub { [] },
    documentation => qq{List of packages to use. Value is text between use keyword and the semi-colon on the end of the line, to allow you at add args to the use.},
);

has uses_ok => (
    is      => "rw",
    isa     => PerlPackageList,
    default => sub { [] },
    documentation => qq{List of packages to use_ok.},
);

has use_test => (
    is      => "rw",
    isa     => Str,
    documentation => qq{Str list seperated by comma or space of Test:: modules to use.},
);

has deep => (
    is      => "rw",
    isa     => Bool,
    documentation => qq{Use Test::Deep.},
);


method build {
    $self->uses->unshift("Test::Deep")
        if $self->deep && !($self->uses ~~ "Test::Deep");

    if ( $self->use_test ) {
        $self->uses->push("Test::$_") foreach split /[, ]/, $self->use_test;
    }

    my $file = $self->perl_t_dir->file( $self->name.".t" );
    $self->tt_write( $file => 'test.t.tt' );
}

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 SYNOPSIS

 $ nufoo Perl.Test.More --name NAME [ATTRIBUTES] 

=head1 DESCRIPTION

Builds Test::More .t files.

=head1 ATTRIBUTES 

=over 4

=item name

Name of the test. Used to create the test file name as <name>.t.

=item uses

Package names to use in the test.

=item uses_ok

List of packages to use_ok. Creates a BEGIN block and use_ok the packages
given.

=item deep

Use Test::Deep

=item use_test

String of package names (seperated by comma or space) under Test:: to use. E.g.
"Deep,Exception" would "use Test::Deep; use Test::Exception;" in the built
test.

=back

=head1 EXAMPLES 

 nufoo Perl.Test.More --name test
 
 nufoo Perl.Test.More --name basic --deep
 
 nufoo Perl.Test.More --name foo --use_test Deep,Exception --uses My::Foo

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
