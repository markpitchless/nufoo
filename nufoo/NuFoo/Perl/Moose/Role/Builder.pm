package NuFoo::Perl::Moose::Role::Builder;

=head1 NAME

NuFoo::Perl::Moose::Role::Builder - Builds Moose roles.

=cut

use CLASS;
use Moose;
use MooseX::Method::Signatures;
use Log::Any qw($log);

extends 'NuFoo::Perl::Moose::Class::Builder';

# We don't override the base class build as we just want different templates.

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 SYNOPSIS

 nufoo Perl.Moose.Role --class CLASS [ATTRIBUTES] 

=head1 DESCRIPTION

Builds L<Moose> roles. 

=head1 ATTRIBUTES 

=over 4

=item class

The package name for the new role.

=item has

List of attributes for the class. Each attribute is a hashref with a name
attribute to name the attribute the rest of the keys corrisond to the
arguments passed to has when setting up a class.

The attribute can also be given as a string of the form:

 <type>:<name>=<default>

type and default are optional.

=item with

List of roles this class consumes.

=back

=head1 EXAMPLES 

 nufoo Perl.Moose.Role --class Foo::Role::Explodable --has Bool:is_exploded

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
