package NuFoo::Build::Ros::Node::Cpp;

our $VERSION = '0.01';

use Moose;
use MooseX::Method::Signatures;
use NuFoo::Types qw();
use Log::Any qw($log);
use MooseX::Types::Moose qw(:all);
use NuFoo::Types qw(:all);
use NuFoo::Types::Ros qw(:all);
use Path::Class;

extends 'NuFoo::Builder';

with 'NuFoo::Role::TT',
     'NuFoo::Role::Ros::Node';

has node_src_file => (
    is => "rw",
    isa => File,
    required => 1,
    lazy_build => 1,
);

method _build_node_src_file { 
    file($self->src_dir, $self->name . ".cpp");
}

has class => (
    is => "rw",
    isa => Str,
    required => 1,
    lazy_build => 1,
);

method _build_class {
    my $class = $self->name;
    $class =~ s/_(\w)/\U$1/;
    return ucfirst $class;
}


method build() {
    $self->tt_write( $self->node_src_file => "node.cpp.tt" );
    if ( $self->dynamic_reconfigure ) {
        $self->tt_write( $self->cfg_file => "dynamic_reconfigure.cfg.tt" );
    }
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
__END__

=pod

=head1 NAME

NuFoo::Build::Ros::Node::Cpp - 

=head1 SYNOPSIS

 nufoo Ros.Node.Cpp [ATTRIBUTES] 

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head1 METHODS

=head1 EXAMPLES

 nufoo Ros.Node.Cpp

=head1 SEE ALSO

L<NuFoo>, L<NuFoo::Builder>, L<perl>.

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

