package NuFoo::Role::Perl::Moose::Thing;

=head1 NAME

NuFoo::Role::Perl::Moose::Thing - Role for builders that create Moose
classes and roles. 

=cut

use Moose::Role;
use NuFoo::Types qw(
    ArrayRefOfStr
    PerlPackageName
    PerlPackageList
    PerlMooseAttributeSpecList
);

has class => (
    is            => "rw",
    isa           => PerlPackageName,
    documentation => qq{The class name.},
);

has uses => (
    is            => "rw",
    isa           => ArrayRefOfStr,
    default       => sub { [] },
    documentation => qq{Classs this class should use. Value is the full use string between the use keyword and the semi colon.},
);

# Can not be used by roles.
has extends => (
    is            => "rw",
    isa           => PerlPackageList,
    default       => sub { [] },
    accessor      => "class_extends", # Don't stomp on the Moose keyword
    documentation => qq{Class names the new class extends. Multiple allowed.},
);

has with => (
    is            => "rw",
    isa           => PerlPackageList,
    default       => sub { [] },
    accessor      => "class_with", # Don't stomp on the Moose keyword
    documentation => qq{Roles this class does. Multiple allowed.},
);

has has => (
    is            => "rw",
    isa           => PerlMooseAttributeSpecList,
    default       => sub { [] },
    coerce        => 1,
    accessor      => "class_has", # Don't stomp on the Moose keyword
    documentation => qq{Attributes for the class. Mutiple allowed.},
);

1;
__END__

=head1 SYNOPSIS

 does "NuFoo::Role::Perl::Moose::Thing";

=head1 DESCRIPTION

=head1 ATTRIBUTES 

=head2 class

=head2 uses

=head2 extends

=head2 with

=head2 has

=head1 METHODS 

=head1 SEE ALSO

L<NuFoo>, L<NuFoo::Builder>, L<Moose>, L<perl>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

See L<NuFoo>.

=cut
