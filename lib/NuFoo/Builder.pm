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
use File::Spec::Functions qw(rel2abs splitpath);
use NuFoo;

with 'MooseX::Getopt', 'NuFoo::Role::GetoptUsage';

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
    if ($args{nufoo}) {
        my $conf    = $args{nufoo}->conf;
        my $section = $class->build_name;
        my %extra;
        foreach ( $class->build_attribs ) {
            my $name = $section . "." . $_->name;
            my $val  = $conf->get($name);
            $extra{$_->name} = $val if defined $val;
        }
        %args = ( %args, %extra ) if keys %extra; 
    }

    # Process an argv (command line args), if we got one.
    # Note we pass the current args, with conf included, to stop
    # _attrs_to_options from generating required options (which cause a die)
    # for options we already have.
    if ( my $argv = delete $args{argv} ) {
        Getopt::Long::Configure('no_pass_through');
        my %processed = $class->_parse_argv(
            options => [ $class->_attrs_to_options( \%args ) ],
            params  => { argv => $argv },
        );
        %args = ( %args, %{$processed{params}} ) if ref $processed{params};
    }

    return $class->$orig(%args);
};

# Override method from the role to show the builder name in the usage.
sub _usage_format {
    my $proto = shift;
    my $class = ref $proto || $proto;
    my $name  = NuFoo->builder_class_to_name($class);
    return "Usage:\n    %c $name OPTIONS";
}

method home_dir($self:) {
    my $class = blessed $self || $self;
    (my $inc_file = $class) =~ s/::/\//g;
    $inc_file .= ".pm";
    my $file  = $INC{$inc_file} || return undef; 
    my (undef, $dir, undef) = splitpath($file);
    return rel2abs($dir);
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
