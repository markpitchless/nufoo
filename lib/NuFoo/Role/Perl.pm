
package NuFoo::Role::Perl;

our $VERSION = '0.01';

use Moose::Role;
use MooseX::Method::Signatures;
use NuFoo::Core::Types qw(Dir File);
use Log::Any qw($log);
use Path::Class qw(dir);

has perl_dir => (
    is          => "rw",
    isa         => Dir,
    coerce      => 1,
    lazy_build  => 1,
    documentation => qq{Directory for perl library files. Default looks for a suitable dir (./lib ./Lib) or uses pwd.},
);

method _build_perl_dir {
    my $outdir = $self->nufoo->dir;
    foreach (qw(lib Lib)) {
        my $dir = $outdir->subdir($_);
        if (-d $dir) {
            $log->info("Using perl dir '$dir'");
            return dir($_); # return relative to $outdir
        }
    }
    return dir(".");
}

has perl_t_dir => (
    is         => "rw",
    isa        => Dir,
    coerce     => 1,
    lazy_build => 1,
    documentation => qq{Dir for perl test (.t) files. Default looks for a suitable dir (./t <perl_dir>/t) or uses pwd.},
);

method _build_perl_t_dir {
    my $outdir = $self->nufoo->dir;
    foreach ('t', [$self->perl_dir, 't']) {
        my $dir = $outdir->subdir($_);
        if (-d $dir) {
            $log->info("Using perl dir '$dir'");
            return dir($_); # return relative to $outdir
        }
    }
    return dir(".");
}

method perl_package2file (Str $name) {
    my $dir = $self->perl_dir;
    return $dir->file(split( /::/, "$name\.pm" ));
}

method perl_class2file (Str $name) { $self->perl_package2file($name) }

no Moose::Role;

1;
__END__

=head1 NAME

NuFoo::Role::Perl -  

=cut

=head1 SYNOPSIS

 use Moose;

 with 'NuFoo::Role::Perl';

=head1 DESCRIPTION

=head1 ATTRIBUTES 

=head2 perl_dir

=head2 perl_t_dir

=head1 METHODS

=head2 perl_package2file

Convert a perl package name to a file name. This will include the use of
L<perl_dir> if found or set.

=head2 perl_class2file

Alias to perl_package2file.

=head1 METHODS 

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
