package NuFoo::Cmd;

=head1 NAME

NuFoo::Cmd - Impliments the command line interface to NuFoo. 

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

use Moose;
use MooseX::Method::Signatures;

extends 'NuFoo';

with 'MooseX::Getopt';

has help => ( is => 'rw', isa => 'Bool',
    documentation => "Display help message" );

method run() {
    my @argv = @{$self->extra_argv};
    my $name = shift @argv || die "No builder name";
}

1;
__END__

=head1 SYNOPSIS

 #!/usr/bin/perl
 my $nufoo = NuFoo::Cmd->new_with_options;
 $nufoo->run;

=head1 DESCRIPTION

=head1 METHODS 

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.

See L<NuFoo/BUGS> for details of how to report bugs.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc NuFoo

See L<NuFoo/BUGS> for details of more support options. 

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2009 Mark Pitchless.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
