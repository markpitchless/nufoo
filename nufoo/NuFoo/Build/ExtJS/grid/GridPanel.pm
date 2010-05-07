package NuFoo::Build::ExtJS::grid::GridPanel;

=head1 NAME

NuFoo::Build::ExtJS::grid::GridPanel - Builds a Ext.grid.GridPanel sub class.

=cut

use CLASS;
use Log::Any qw($log);
use Moose;
use MooseX::Method::Signatures;
use NuFoo::Types qw(File Dir);

extends 'NuFoo::Build::ExtJS::Component';

has '+extends' => ( default => "Ext.grid.GridPanel" );

# class-extends.js.tt

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 SYNOPSIS

 nufoo ExtJS.Preconf.Grid --class CLASS [ATTRIBUTES] 

=head1 DESCRIPTION

Builds an Ext.grid.GridPanel sub class.

=head1 ATTRIBUTES 

=over 4

=item class

=back

=head1 EXAMPLES 

 nufoo ExtJS.Preconf.Grid --class Foo.UserGrid

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