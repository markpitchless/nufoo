package NuFoo::Build::Perl::Moose::Role;

=head1 NAME

NuFoo::Build::Perl::Moose::Role - Builds Moose roles.

=cut

use CLASS;
use Moose;
use MooseX::Method::Signatures;
use Log::Any qw($log);

extends 'NuFoo::Build::Perl::Moose::Class';

# We don't override the base class build as we just want different templates.

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 DESCRIPTION

Builds L<Moose> roles. Sub class of
L<NuFoo::Build::Perl::Moose::Class|Perl.Moose.Class>.

=head1 ATTRIBUTES 

See L<NuFoo::Build::Perl::Moose::Class|Perl.Moose.Class> for inherited
attributes.

=head2 class

The package name for the new role.

=head1 EXAMPLES 

 nufoo Perl.Moose.Role --class Foo::Role::Explodable --has Bool:is_exploded

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
