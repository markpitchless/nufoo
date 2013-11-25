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
use MooseX::StrictConstructor;
use Log::Any qw($log);
use File::Spec::Functions qw(rel2abs splitpath catdir);
use NuFoo;

with 'MooseX::Getopt::Usage',
     'MooseX::Getopt::Usage::Role::Man';

has nufoo => (
    is       => "ro",
    isa      => "NuFoo",
    required => 1,
    traits   => ['NoGetopt'],
    handles  => [qw(write_file)],
);

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;
    my %args  = ref $_[0] eq 'HASH' ? %{$_[0]} : @_;

    # Load config from the NuFoo object
    # Searches in role namespace and then builder name
    if ($args{nufoo}) {
        my $conf     = $args{nufoo}->conf;
        my @sections = $class->build_name;
        foreach ( $class->meta->calculate_all_roles_with_inheritance ) {
            my $name = $_->name;
            next if $name =~ /\|/; # wtf are these piped name lists?
            $name =~ s/^NuFoo::Role::// || next;
            $name =~ s/::/\./g;
            unshift @sections, $name;
        }
        my %extra;
        foreach my $section (@sections) {
            foreach ( $class->build_attribs ) {
                my $name = $section . "." . $_->name;
                my $val  = $conf->get($name);
                $extra{$_->name} = $val if defined $val;
            }
        }
        # Note that args (command line, new) overrides extra (conf file)
        %args = ( %extra, %args ) if keys %extra;
    }

    return $class->$orig(%args);
};

# Show the builder name in the usage.
# Note: If a builder defines a SYNOPSIS in its POD that will override.
sub getopt_usage_config {
    my $proto = shift;
    my $class = ref $proto || $proto;
    my $name  = NuFoo->builder_class_to_name($class);
    return ( format => "%c $name %r [OPTIONS]" );
}

method home_dir($self:) {
    my $class = blessed $self || $self;
    (my $inc_file = $class) =~ s/::/\//g;
    $inc_file .= ".pm";
    my $file  = $INC{$inc_file} || return undef; 
    my (undef, $dir, $name) = splitpath($file);
    $name =~ s/\.pm$//;
    my $home_dir = catdir($dir, $name);
    return rel2abs($home_dir);
}

method build() {
    my $class = blessed $self;
    confess "method build is abstract, $class must impliment";
}

sub build_name {
    my $class = shift;
    $class = blessed $class || $class;
    return NuFoo->builder_class_to_name($class);
}

sub build_attribs {
    my $class = shift;
    grep {
        # Ready for when we add a specific trait for Build attributes.
        #$_->does("NuFoo::Meta::Attribute::Trait::Build")
        #    or
        $_->name !~ /^_/
    } grep {
        !$_->does('NuFoo::Meta::Attribute::Trait::NoBuild')
    } $class->meta->get_all_attributes
}

sub build_vars {
    my $self = shift;
    my $vars = {};
    foreach my $attr ($self->build_attribs) {
        my $name = $attr->name;
        my $meth = $attr->get_read_method;
        $vars->{$name} = $self->$meth;
    } 
    return $vars;
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

=head2 build_name

Name of this builder in dot notation.

=head2 home_dir

Return the home directory for this builder. This is the dir for resources such
as templates.

Path returned as absolute path string.

=head2 build_attribs

Return list of attributes (meta objects) that are used to control the build.

=head2 build_vars

Util method that returns a HashRef of the builder args with values from their
accessors.

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
