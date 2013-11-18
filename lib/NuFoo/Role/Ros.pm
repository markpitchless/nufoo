package NuFoo::Role::Ros;

our $VERSION = '0.01';

use Moose::Role;
use MooseX::Method::Signatures;
use MooseX::Types::Moose qw(:all);
use NuFoo::Types qw(Dir File);
use Log::Any qw($log);
use Path::Class;

has ros_distro => (
    is      => "rw",
    isa     => Str,
    default => sub { $ENV{ROS_DISTRO} || "" },
    documentation => qq{Ros distro veriosn (e.g. hydro) of the current environment.},
);

has src_dir => (
    is      => "rw",
    isa     => Dir,
    coerce        => 1,
    lazy_build    => 1,
    documentation => qq{Directory for src files. Looks for suitable dir or uses current as default.},
);
method _build_src_dir {
    my $outdir = $self->nufoo->outdir;
    foreach (qw(src)) {
        my $dir = dir($outdir, $_);
        if (-d $dir) {
            $log->info("Using src dir '$dir'");
            return $_; # return relative to $dir
        }
    }
    return ".";
}

has include_dir => (
    is      => "rw",
    isa     => Dir,
    coerce        => 1,
    lazy_build    => 1,
    documentation => qq{Directory for header files. Looks for suitable dir or uses current as default.},
);
method _build_include_dir {
    my $outdir = $self->nufoo->outdir;
    foreach (qw(include)) {
        my $dir = dir($outdir, $_);
        if (-d $dir) {
            $log->info("Using include dir '$dir'");
            return $_; # return relative to $dir
        }
    }
    return ".";
}

has scripts_dir => (
    is      => "rw",
    isa     => Dir,
    coerce        => 1,
    lazy_build    => 1,
    documentation => qq{Directory for scripts (executable) files like python nodes. Looks for suitable dir or uses current as default.},
);
method _build_scripts_dir {
    my $outdir = $self->nufoo->outdir;
    foreach (qw(scripts bin)) {
        my $dir = dir($outdir, $_);
        if (-d $dir) {
            $log->info("Using scripts dir '$dir'");
            return $_; # return relative to $dir
        }
    }
    return ".";
}


no Moose::Role;

1;
__END__

=pod

=head1 NAME

NuFoo::Role::Ros - Role for builders that generate ROS code.

=head1 SYNOPSIS

 use Moose;

 with 'NuFoo::Role::ROS';

=head1 DESCRIPTION

See http://ros.org.

=head1 ATTRIBUTES

=head2 ros_distro

=head2 src_dir

=head2 include_dir

=head2 scripts_dir

=head1 METHODS

=head1 SEE ALSO

L<NuFoo>, L<Moose>, L<perl>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT and LICENSE

Copyright 2013

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

