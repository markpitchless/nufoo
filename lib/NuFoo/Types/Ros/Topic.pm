package NuFoo::Types::Ros::Topic;

our $VERSION = '0.01';

use Moose;
use MooseX::Types::Moose qw(:all);
use NuFoo::Types qw(:all);
use NuFoo::Types::Ros qw(:all);
use MooseX::Types -declare => [qw( RosTopic RosTopicList )];

has topic    => ( is => "rw", isa => RosResourceName, required => 1 );
has msg_type => ( is => "rw", isa => RosType, required => 1 );

has var_name => ( is => "rw", isa => Str, lazy_build => 1 );
sub _build_var_name {
    my $self = shift;
    my $name = $self->topic;
    $name =~ s{/}{_}g;
    return $name;
}

has cpp_type => ( is => "ro", isa => Str, lazy_build => 1 );
sub _build_cpp_type {
    my $self = shift;
    my $class = $self->msg_type;
    $class =~ s{/}{::}g;
    return $class;
}

has py_type => ( is => "ro", isa => Str, lazy_build => 1 );
sub _build_py_type {
    my $self = shift;
    my $name = $self->msg_type;
    $name =~ s{^.*?/}{}g;
    return $name;
}


sub new_from_string {
    my $proto = shift;
    my $class = ref $proto || $proto;
    my $str = shift || confess "Need a string";
    my ($type,$topic) = $str =~ m{
        ^
        ([A-Za-z]\w+/[A-Za-z]\w+) # \1 type
        :
        ([A-Za-z~/][\w+_/]*) # \2 topic
        $
    }x;
    my $args = { topic => $topic, msg_type => $type };
    return $class->new($args);
}

sub as_str {
    my $self = shift;
    my $str = $self->msg_type . ":" . $self->topic;
}

class_type RosTopic, { class => "NuFoo::Types::Ros::Topic" };

subtype RosTopicList,
    as ArrayRef[RosTopic];

coerce RosTopic,
    from Str,
    via { NuFoo::Types::Ros::Topic->new_from_string($_) };

coerce RosTopicList,
    from ArrayRefOfStr,
    via { [ map { NuFoo::Types::Ros::Topic->new_from_string($_) } @$_ ] };


__PACKAGE__->meta->make_immutable;
no Moose;

1;
__END__

=pod

=head1 NAME

NuFoo::Types::Ros::Topic - Small class representing ROS topic (publisher or
subscriber).

=head1 SYNOPSIS

 my $obj = NuFoo::Types::Ros::Topic->new();

=head1 DESCRIPTION

Class for the param type, see L<NuFoo::Types::Ros>.

=head1 ATTRIBUTES

=head2 msg_type

=head2 topic

=head1 METHODS

=head1 SEE ALSO

L<NuFoo>, L<NuFoo::Types::Ros>, L<Moose>, L<perl>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 ACKNOWLEDGEMENTS


=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 COPYRIGHT

Copyright 2013 

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

