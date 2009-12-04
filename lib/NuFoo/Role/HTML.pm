
package NuFoo::Role::HTML;

=head1 NAME

NuFoo::Role::HTML - Role for HTML producing builders. 

=cut

our $VERSION = '0.01';

use Moose::Role;
use MooseX::Method::Signatures;
use NuFoo::Core::Types qw(Dir);
use Log::Any qw($log);
use Path::Class;

has html_dir => (
    is            => "rw",
    isa           => Dir,
    coerce        => 1,
    lazy_build    => 1,
    documentation => qq{Directory for HTML files. Looks for suitable dir or uses current as default.},
);

method _build_html_dir {
    my $outdir = $self->nufoo->dir;
    foreach (qw(htdocs www)) {
        my $dir = dir($outdir, $_);
        if (-d $dir) {
            $log->info("Using html dir '$dir'");
            return $_; # return relative to $dir
        }
    }
    return ".";
}

no Moose::Role;

1;
__END__

=head1 SYNOPSIS

 use Moose;

 does 'NuFoo::Role::HTML';

=head1 DESCRIPTION

=head1 ATTRIBUTES 

=head2 html_dir

Directory to write HTML files. Default check for a htdocs or www directory and
uses that if found, otherwise the current dir.

=head1 METHODS 

=head1 SEE ALSO

L<perl>, L<Moose>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2009 

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
