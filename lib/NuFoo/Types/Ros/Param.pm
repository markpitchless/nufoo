package NuFoo::Types::Ros::Param;

our $VERSION = '0.01';

use Moose;
use MooseX::Types::Moose qw(:all);
use NuFoo::Types qw(:all);
use NuFoo::Types::Ros qw(:all);
use MooseX::Types -declare => [qw( RosParam RosParamList )];

has name => (
    is      => "rw",
    isa     => RosResourceName,
);

has data_type => (
    is      => "rw",
    isa     => RosFieldType,
    default => "string",
);

has default => (
    is      => "rw",
    isa     => Undef|Str,
);

sub new_from_string {
    my $proto = shift;
    my $class = ref $proto || $proto;
    my $str = shift || confess "Need a string";
    my ($type,$name,$def) = $str =~ m/
        ^
        (?:(\w+):)?   # Optional type \1
        ([\w\d_]+)    # The attribute name \2
        (?:=(.*))?    # Optional default \3
        $
    /x;
    my $args = { name => $name, default => $def };
    $args->{data_type} = $type if $type;
    return $class->new($args);
}

sub as_str {
    my $self = shift;
    my $str = $self->type . ":" . $self->name;
    $str .= "=".$self->default if defined $self->default;

}

class_type RosParam, { class => "NuFoo::Types::Ros::Param" };

subtype RosParamList,
    as ArrayRef[RosParam];

coerce RosParam,
    from Str,
    via { NuFoo::Types::Ros::Param->new_from_string($_) };

coerce RosParamList,
    from ArrayRefOfStr,
    via { [ map { NuFoo::Types::Ros::Param->new_from_string($_) } @$_ ] };


__PACKAGE__->meta->make_immutable;
no Moose;

1;
__END__

=pod

=head1 NAME

NuFoo::Types::Ros::Param - 

=head1 SYNOPSIS

 my $obj = NuFoo::Types::Ros::Param->new();

=head1 DESCRIPTION

Class for the param type, see L<NuFoo::Types::Ros>.

=head1 ATTRIBUTES

=head2 name

=head2 type

=head2 default

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

