package NuFoo::Build::Perl::MooseX::Types;

=head1 NAME

NuFoo::Build::Perl::MooseX::Types - Builds MooseX::Types type libraries.

=cut

use CLASS;
use Log::Any qw($log);
use Moose;
use MooseX::Method::Signatures;
use NuFoo::Types qw();

extends 'NuFoo::Build::Perl::Package';

# We just override some of the templates.

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 SYNOPSIS

 nufoo Perl.MooseX.Types [ATTRIBUTES] 

=head1 DESCRIPTION

Builds L<MooseX::Types> type libraries.

=head1 ATTRIBUTES 

See L<NuFoo::Perl::Moose::Class>.

=over 4


=back

=head1 EXAMPLES 

 nufoo Perl.MooseX.Types --class Foo::Types

=head1 SEE ALSO

L<NuFoo>, L<NuFoo::Builder>, L<NuFoo::Build::Perl::Moose::Class>,
L<MooseX::Types>

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 ACKNOWLEDGEMENTS

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 COPYRIGHT & LICENSE

See L<NuFoo>.

=cut
