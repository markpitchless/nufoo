package NuFoo::Core::Role::Perl::Moose::Thing;

=head1 NAME

NuFoo::Core::Role::Perl::Moose::Thing - Role for builders that create Moose
classes and roles. 

=cut

use Moose::Role;
use NuFoo::Core::Types qw(
    PerlPackageName
    PerlPackageList
    PerlMooseAttributeSpecList
);

has class => (
    is            => "rw",
    isa           => PerlPackageName,
    required      => 1,
    documentation => qq{The class name.},
);

# Can not be used by roles.
has extends => (
    is            => "rw",
    isa           => PerlPackageList,
    default       => sub { [] },
    documentation => qq{Class names the new class extends. Multiple allowed.},
);

has with => (
    is            => "rw",
    isa           => PerlPackageList,
    default       => sub { [] },
    documentation => qq{Roles this class does. Multiple allowed.},
);

has has => (
    is            => "rw",
    isa           => PerlMooseAttributeSpecList,
    default       => sub { [] },
    coerce        => 1,
    documentation => qq{Attributes for the class. Mutiple allowed.},
);

1;
__END__

=head1 SYNOPSIS

 does "NuFoo::Core::Role::Perl::Moose::Thing";

=head1 DESCRIPTION

=head1 ATTRIBUTES 

=head2 author

=head2 email

=head1 METHODS 

=head1 SEE ALSO

L<NuFoo>, L<NuFoo::Core::Builder>, L<Moose>, L<perl>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

See L<NuFoo>.

=cut
