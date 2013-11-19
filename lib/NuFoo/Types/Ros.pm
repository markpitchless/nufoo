package NuFoo::Types::Ros;

our $VERSION = '0.01';

use strict;
use warnings;

use MooseX::Types -declare => [qw(
    RosNodeName
    RosPackageName
    RosResourceName
    RosType
    RosFieldType
    RosParam
)];
use MooseX::Types::Moose qw(:all);

subtype RosNodeName,
    as Str,
    where { $_ =~ m{^[A-Za-z][\w_]*$} },
    message { "Not a valid node name." };

subtype RosPackageName,
    as Str,
    where { $_ =~ m{^[A-Za-z][\w+_/]*$} },
    message { "Not a valid package name." };

# Topics, params etc
subtype RosResourceName,
    as Str,
    where { $_ =~ m{^[A-Za-z~/][\w+_/]*$} },
    message { "Not a valid reource name." };

# TODO A Package Resource Name. e.g. std_msgs/Bool, camera/Node
subtype RosType,
    as Str,
    where { $_ =~ m{^[A-Za-z]\w+/[A-Za-z]?\w$} },
    message { "Not a valid package resource name." };

# Type in messages, services etc
subtype RosFieldType,
    as Str,
    where { $_ =~ m{^[\w\[\]/_]*$} },
    message { "Not a valid field type '$_'." };


1;
__END__

=pod

=head1 NAME

NuFoo::Types::Ros - ROS MooseX:Types library.

=cut

=head1 SYNOPSIS

 use Moose;
 use MooseX::Types::Moose qw(:all);
 use NuFoo::Types::Ros qw( RosNodeName );

 has name => ( is => 'rw', isa => RosNodeName );

=head1 DESCRIPTION


=head1 SEE ALSO

L<http://wiki.ros.org/Names>,

L<perl>, L<MooseX::Types>, L<NuFoo>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 ACKNOWLEDGEMENTS

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 COPYRIGHT

Copyright 2013 Mark Pitchless

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
