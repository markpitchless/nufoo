package NuFoo::Builder;

=head1 NAME

NuFoo::Builder - Base class for builders. 

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';
use 5.010;
use Moose;
use MooseX::Method::Signatures;

with 'MooseX::Getopt';

before new_with_options => sub {
    Getopt::Long::Configure('no_pass_through'); 
};

method build() {
    my $class = blessed $self;
    confess "method build is abstract, $class must impliment";
}

1;
__END__

=head1 SYNOPSIS

=head1 DESCRIPTION

A builder does the actual work of generating files for the user. This is the
base class all builders must be based on.

=head1 METHODS 

=head2 build 

Sub classers must impliment with their build logic.

=head1 SEE ALSO

L<NuFoo>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.

See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2009 Mark Pitchless.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
