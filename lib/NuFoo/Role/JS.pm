
package NuFoo::Role::JS;

=head1 NAME

NuFoo::Role::JS - Role for Javascript builders. 

=cut

our $VERSION = '0.01';

use Moose::Role;
use MooseX::Method::Signatures;
use NuFoo::Core::Types qw(Dir);
use Log::Any qw($log);
use Path::Class;

has js_dir => (
    is            => "rw",
    isa           => Dir,
    coerce        => 1,
    lazy_build    => 1,
    documentation => qq{Directory for Javascript source files. Looks for suitable dir or uses current as default.},
);

method _build_js_dir {
    my $outdir = $self->nufoo->dir;
    foreach (qw(js htdocs/js)) {
        my $dir = dir($outdir, $_);
        if (-d $dir) {
            $log->info("Using js dir '$dir'");
            return $_; # return relative to $dir
        }
    }
    return ".";
}

method js_class2file (Str $class) {
    my @parts = split(/\./, $class);
    $parts[$#parts] .= ".js";
    return file( $self->js_dir, @parts );
}


no Moose::Role;

1;
__END__

=head1 SYNOPSIS

 use Moose;

 with 'NuFoo::Role::JS';

=head1 DESCRIPTION

=head1 ATTRIBUTES 

=head2 js_dir

Directory to write JS files. Default checks for a 'js' or 'htdocs/js' directory and
uses if found, otherwise the current dir.

=head1 METHODS 

=head2 js_class2file

Convert the passed class name to a file name. Includes the js_dir.

=head1 SEE ALSO

L<perl>, L<Moose>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2009 Mark Pitchless

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
