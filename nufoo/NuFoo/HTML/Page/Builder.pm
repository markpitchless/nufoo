package NuFoo::HTML::Page::Builder;

=head1 NAME

NuFoo::HTML::Page::Builder - Builds...

=cut

use CLASS;
use Log::Any qw($log);
use Moose;
use MooseX::Method::Signatures;
use MooseX::Types::Moose qw(:all);
use NuFoo::Core::Types qw(File);

extends 'NuFoo::Core::Builder';

with 'NuFoo::Core::Role::TT';

has title => (
    is            => "rw",
    isa           => Str,
    required      => 1,
    documentation => qq{Page title},
);

has file => (
    is            => "rw",
    isa           => File,
    coerce        => 1,
    default       => "index.html",
    documentation => qq{File to write to. Default is index.html},
);


method build {
    $self->tt_write( $self->file, "page.html.tt" ); 
}

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 SYNOPSIS

 nufoo HTML.Page [ATTRIBUTES] 

=head1 DESCRIPTION

Builds...

=head1 ATTRIBUTES 

=over 4

=item title

=item file


=back

=head1 EXAMPLES 

 nufoo HTML.Page

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
