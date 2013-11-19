package NuFoo::Role::Ros::Node;

our $VERSION = '0.01';

use Moose::Role;
use MooseX::Method::Signatures;
use MooseX::Types::Moose qw(:all);
use NuFoo::Types qw(:all);
use NuFoo::Types::Ros qw(:all);
use NuFoo::Types::Ros::Param qw(:all);
use Log::Any qw($log);

with 'NuFoo::Role::Ros';

has name => (
    is      => "rw",
    isa     => RosNodeName,
    required => 1,
);

has package => (
    is      => "rw",
    isa     => RosPackageName,
    required => 1,
);

has params => (
    is      => "rw",
    isa     => RosParamList,
    coerce  => 1,
);

has dynamic_reconfigure => (
    is    => "rw",
    isa   => Bool,
);




no Moose::Role;

1;
__END__

=pod

=head1 NAME

NuFoo::Role::Ros::Node - 

=head1 SYNOPSIS

 use Moose;

 with 'NuFoo::Role::Ros::Node';

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 name

=head2 package

=head2 params

=head1 METHODS

=head1 SEE ALSO

L<Moose>, L<perl>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 ACKNOWLEDGEMENTS


=head1 AUTHOR



=head1 COPYRIGHT

Copyright 2013 

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

