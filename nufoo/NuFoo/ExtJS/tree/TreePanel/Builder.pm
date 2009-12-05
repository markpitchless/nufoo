package NuFoo::ExtJS::tree::TreePanel::Builder;

=head1 NAME

NuFoo::ExtJS::tree::TreePanel::Builder - Builds...

=cut

use CLASS;
use Log::Any qw($log);
use Moose;
use MooseX::Method::Signatures;
use NuFoo::Core::Types qw();

extends 'NuFoo::ExtJS::Component::Builder';

has '+extends' => ( default => "Ext.tree.TreePanel" );

# class-extend.js.tt 

override build => sub {
    my $self = shift;
    super;
    $self->tt_write( [$self->html_t_dir, 'tree.json'], 'tree.json.tt' )
        if $self->test;
};

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 SYNOPSIS

 nufoo ExtJS.tree.TreePanel [ATTRIBUTES] 

=head1 DESCRIPTION

Builds...

=head1 ATTRIBUTES 

=over 4


=back

=head1 EXAMPLES 

 nufoo ExtJS.tree.TreePanel

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