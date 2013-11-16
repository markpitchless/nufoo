package NuFoo::Build::HTML::Page;

=head1 NAME

NuFoo::Build::HTML::Page - Builds a basic HTML page.

=cut

use CLASS;
use Log::Any qw($log);
use Moose;
use MooseX::Method::Signatures;
use MooseX::Types::Moose qw(:all);
use NuFoo::Types qw(File);
use NuFoo::Types::HTML qw( HtmlDocType );

extends 'NuFoo::Builder';

with 'NuFoo::Role::TT',
    'NuFoo::Role::HTML';

has file => (
    is            => "rw",
    isa           => File,
    coerce        => 1,
    lazy_build    => 1,
    documentation => qq{File to write to. Default is index.html in the html dir or build dir.},
);

method _build_file {
    [ $self->html_dir, "index.html" ];
}

has title => (
    is            => "rw",
    isa           => Str,
    required      => 1,
    documentation => qq{Page title},
);

has doctype => (
    is            => "rw",
    isa           => HtmlDocType,
    required      => 1,
    default       => "transitional",
    documentation => qq{Doc type to use, one of strict, transitional or frameset},
);

has lang => (
    is            => "rw",
    isa           => Str,
    documentation => qq{Set language tag on html element},
);

has lang_dir => (
    is            => "rw",
    isa           => Str,
    documentation => qq{Set langauge 'dir' attribute on html element},
);

method build {
    $self->tt_write( $self->file, "page.html.tt" ); 
}

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 DESCRIPTION

Builds a basic HTML page.

=head1 ATTRIBUTES 

=over 4

=item title

=item file

=item doctype

=item lang

=item lang_dir

=back

=head1 EXAMPLES 

 nufoo HTML.Page --title "It's the nufoo!"
 
 nufoo HTML.Page --title "The nufoo!" --dtd strict

=head1 SEE ALSO

L<NuFoo>, L<NuFoo::Builder>.

L<http://www.w3.org/MarkUp/Guide/>,
L<http://www.w3.org/TR/REC-html40/struct/global.html>

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

See L<NuFoo>.

=cut
