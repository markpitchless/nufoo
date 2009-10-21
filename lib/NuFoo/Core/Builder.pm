package NuFoo::Core::Builder;

=head1 NAME

NuFoo::Core::Builder - Base class for builders. 

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';
use 5.010;
use Moose;
use MooseX::Method::Signatures;
use MooseX::StrictConstructor;
use Log::Any qw($log);
use File::Path qw(make_path);
use File::Spec::Functions qw(rel2abs splitpath);

with 'MooseX::Getopt';

has nufoo => (
    is       => "ro",
    isa      => "NuFoo",
    required => 1,
    traits   => ['NoGetopt'],
    handles  => [qw(write_file)],
);

has force => (
    traits        => ['Getopt'],
    is            => 'rw',
    isa           => 'Bool',
    required      => 1,
    default       => 0,
    cmd_aliases   => ['f'],
    documentation => qq{Overright existing files} );

before new_with_options => sub {
    Getopt::Long::Configure('no_pass_through'); 
};

# Override method from the role to show the builder name in the usage.
sub _usage_format {
    my $proto = shift;
    my $class = ref $proto || $proto;
    my $name  = NuFoo->builder_class_to_name($class);
    return "usage: %c $name OPTIONS";
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

1;
__END__

=head1 SYNOPSIS

=head1 DESCRIPTION

A builder does the actual work of generating files for the user. This is the
base class all builders must be based on.

=head1 METHODS 

=head2 home_dir

Return the home directory for this builder. This is the dir for resources such
as template.

Path returned as absolute path string.

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
