package NuFoo::Build::Ros::Node;

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

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;
    my $args = ref $_[0] ? $_[0] : {@_};
    $args->{language} = "py"  if exists $args->{py} && $args->{py};
    $args->{language} = "cpp" if exists $args->{cpp} && $args->{cpp};
    return $class->$orig($args);
};

has language => (
    is => "rw",
    isa => Str,
    predicate => 'has_language',
    required => 1,
    default => "py",
);

has cpp => ( is => "ro", isa => Bool, reader => 'is_cpp', init_arg => 'cpp' );
method is_cpp() {
    return 1 if $self->has_language && $self->language eq "cpp";
    return 0;
}

has py => ( is => "ro", isa => Bool, reader => 'is_py', init_arg => 'py' );
method is_py() {
    return 1 if $self->has_language && $self->language eq "py";
    return 0;
}

has node_src_file => (
    is => "rw",
    isa => File,
    required => 1,
    lazy_build => 1,
);
method _build_node_src_file { 
    file($self->src_dir, $self->name . ".cpp");
}

has node_script_file => (
    is => "rw",
    isa => File,
    required => 1,
    lazy_build => 1,
);
method _build_node_script_file {
    file($self->scripts_dir, $self->name . ".py");
}

# Returns unique list of used message types.
method used_msg_types() {
    my %types;
    for (@{$self->publishers}, @{$self->subscribers}) {
        $types{$_->msg_type}++;
    }
    return keys %types;
}

method used_msg_packages() {
    my @types = $self->used_msg_types;
    my %pkgs;
    @pkgs{ map { s{/.*$}{}; $_ } @types } = (1);
    print "Hello: ", %pkgs, "\n";
    return keys %pkgs;
}

around 'tt_vars' => sub {
    my $orig = shift;
    my $self = shift;
    my $vars = $self->$orig(@_);
    $vars->{used_msg_types} = [$self->used_msg_types];
    $vars->{used_msg_packages} = [$self->used_msg_packages];
    return $vars;
};

method build() {
    if ($self->is_cpp) {
        $self->tt_write( $self->node_src_file => "node.cpp.tt" );
    }
    elsif ($self->is_py) {
        $self->tt_write( $self->node_script_file => "node.py.tt" );
    }
    else {
        confess "Don't now how to build '".$self->language."' nodes.";
    }
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

NuFoo::Build::Ros::Node - 

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head1 METHODS

=head1 EXAMPLES

 nufoo Ros.Node

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

