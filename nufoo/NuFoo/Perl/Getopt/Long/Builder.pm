package NuFoo::Perl::Getopt::Long::Builder;

our $VERSION = '0.01';

use Moose;
use MooseX::Method::Signatures;
use MooseX::Types::Moose qw(:all);
use NuFoo::Types qw(File);
use Log::Any qw($log);

extends 'NuFoo::Perl::Package::Builder';

use MooseX::Types -declare => [qw(
    PerlGetoptSpec
    PerlGetoptSpecList
)];

subtype PerlGetoptSpec,
    as Str,
    where { m/^[^\s]+$/ }, # Proper check of a valid opt string
    message { "Not a valid option spec ($_)" };

subtype PerlGetoptSpecList,
    as ArrayRef[PerlGetoptSpec];

has 'name' => (
    is => "rw",
    isa => Str,
    required => 1,
    documentation => qq{Name of the command},
);

has file => (
    is         => "rw",
    isa        => File,
    required   => 1,
    coerce     => 1,
    lazy_build => 1,
    documentation => qq{Name of the file to write the command to. Default built from name.},
);

has options => (
    is            => "rw",
    isa           => PerlGetoptSpecList,
    default       => sub { [] },
    coerce        => 1,
    documentation => qq{Command line options to add. Multiple allowed.},
);

method _build_file { $self->name }

# We are (a bit messily) using overridding package to make a bin script, as we
# want all the POD stuff.
has '+package' => ( default => 'main', traits => ['NoGetopt'] );
has '+package_file' => ( traits => ['NoGetopt'] );
method _build_package_file { $self->file }

# Override package.pm.tt

__PACKAGE__->meta->make_immutable;
no Moose;

1;
__END__

=pod

=head1 NAME

NuFoo::Perl::Getopt::Long::Builder - Builds Getopt::Long based perl commands.

=head1 SYNOPSIS

 nufoo Perl.Getopt.Long [ATTRIBUTES] 

=head1 DESCRIPTION

Builds L<Getopt::Long> and L<Pod::Usage> based perl commands. A basic command
is built with --help and m--an options already setup.

=head1 ATTRIBUTES

=head1 METHODS

=head1 EXAMPLES

 nufoo Perl.Getopt.Long --name foo

 nufoo Perl.Getopt.Long --name foo --opt 'verbose|v!' --opt 'quiet|q' --opt 'bar=s'

=head1 SEE ALSO

L<NuFoo>, L<NuFoo::Builder>, L<perl>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 ACKNOWLEDGEMENTS


=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 COPYRIGHT

Copyright 2010 Mark Pitchless

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

