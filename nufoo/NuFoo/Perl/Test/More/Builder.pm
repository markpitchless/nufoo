package NuFoo::Perl::Test::More::Builder;

=head1 NAME

NuFoo::Perl::Test::More::Builder - Builds Test::More .t files.

=cut

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

extends 'NuFoo::Core::Builder';

with 'NuFoo::Core::Role::TT';

has name => (
    is      => "rw",
    isa     => "Str",
    required => 1,
    documentation => qq{The test name. Used for filename.},
);

has uses => (
    is      => "rw",
    isa     => PerlPackageList,
    documentation => qq{List of packages to use.},
);

has deep => (
    is      => "rw",
    isa     => "Bool",
    documentation => qq{Use Test::Deep.},
);


method build {
    my $file = $self->name . ".t";
    my $out  = $self->tt_process( 'test.t.tt' );
    $self->write_file( $file, \$out );
}

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 SYNOPSIS

 $ nufoo Perl.Test.More ATTRIBUTES 

=head1 DESCRIPTION

Builds Test::More .t files.

=head1 ATTRIBUTES 

=over 4

=item name

=item uses

=item deep


=back

=head1 EXAMPLES 

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
