
package NuFoo::Types::HTML;

our $VERSION = '0.01';

use strict;
use warnings;

use MooseX::Types -declare => [qw(
    HtmlDocType
)];
use MooseX::Types::Moose qw( :all );

subtype HtmlDocType,
    as Str,
    where { $_ =~ /strict|transitional|frameset/ },
    message { "Value $_ is not one of strict, transitional or frameset" };

#coerce HtmlDocType,
#    from Int,
#    via { abs };

1;
__END__

=pod

=head1 NAME

NuFoo::Types::HTML - HTML MooseX:Types library. 

=cut

=head1 SYNOPSIS

 use Moose;
 use MooseX::Types::Moose qw(:all);
 use NuFoo::Types::HTML qw( HtmlDocType );

 has doctype => ( is => 'rw', isa => HtmlDocType );

=head1 DESCRIPTION


=head1 SEE ALSO

L<perl>, L<MooseX::Types>, L<NuFoo>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 ACKNOWLEDGEMENTS


=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 COPYRIGHT

Copyright 2009 Mark Pitchless

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
