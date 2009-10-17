package NuFoo::Core::Types;

=head1 NAME

NuFoo::Core::Types - The NuFoo types library. 

=cut

our $VERSION = '0.01';

use MooseX::Types -declare => [qw(
    PerlPackageName
    PerlPackageList
)];

use MooseX::Types::Moose qw( :all );

subtype PerlPackageName,
    as Str,
    where { m/^\w+(::\w+)?$/ },
    message { "The string ($_) is not a valid package/class name" },
;

subtype PerlPackageList,
    as ArrayRef[PerlPackageName],
    message { "There is an invalid package/class name in ".join(", ", @$_) },
;

no Moose::Util::TypeConstraints;

1;
__END__

=head1 SYNOPSIS

 use Moose;
 use NuFoo::Core::Types qw( PerlPackageName );

 has class => ( is => 'rw', isa => PerlPackageName );

=head1 DESCRIPTION

The type library for L<NuFoo> using L<MooseX::Types>.

=head1 TYPES

=head2 PerlPackageName

A Str that is a valid perl package/class name.

=head1 ATTRIBUTES 

=head1 METHODS 

=head1 SEE ALSO

L<perl>, L<Moose>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.

See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

See L<NuFoo>.

=cut
