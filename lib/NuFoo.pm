package NuFoo;

=head1 NAME

NuFoo - Developer tool for creating new boilerplace files using a set of builder modules.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

use Moose;
use MooseX::Method::Signatures;

has include_path => (
    is         => 'rw',
    isa        => 'ArrayRef',
    lazy_build => 1,
    auto_deref => 1
);

method _build_include_path () {
    return [
        "./nufoo",
        "./.nufoo",
        "$ENV{HOME}/.nufoo",
        '/usr/local/share/nufoo',
    ];
}

method load_builder (Str $name) {
    local @INC = @INC;
    unshift @INC, $self->include_path;
    my $class = $self->builder_name_to_class($name);
    eval "use $class";
    return undef if $@ =~ m/^Can't locate .*? in \@INC/;
    die $@ if $@;
    return $class;
}

method builder_name_to_class($class: Str $name) {
    $name =~ s/\./::/g;
    $name =~ s/\//::/g;
    return "NuFoo::$name";
}

method builder_class_to_name($class: Str $name) {
    $name =~ s/^NuFoo:://;
    $name =~ s/::/\./g;
    return $name;
}

1;
__END__

=head1 SYNOPSIS

This is the internal library for NuFoo, you probably want the command line
interface, L<nufoo>:

 $ nufoo --help
 $ nufoo Perl.Moose.Class --name='My::Foo'

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 include_path

Array of directories to search for builders in.

=head1 METHODS 

=head2 load_builder

 load_builder( Str $name );

Load the builder given by name, returing the builders class name if loaded.
Returns undef if the builder is not found and throws an error if the builder
fails to load.

Builders are searched for in the normal perl include path as well as the
L<include_path> attrib on the NuFoo object.

=head2 builder_name_to_class

 builder_name_to_class( Str $name );

Return the class name for the builder name given. Builder names can be given
using . or :: or / as a seperator. The name is additionally prefixed with
NuFoo:: to keep them all in a namespace out of the way of the rest of perl.
e.g.

 Perl.Moose.Class -> NuFoo::Perl::Moose::Class
 NuFoo.Builder    -> NuFoo::NuFoo::Builder
 HTML/Page        -> NuFoo::HTML::Page

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.

Please report any bugs or feature requests to C<bug-nufoo at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=NuFoo>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc NuFoo


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=NuFoo>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/NuFoo>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/NuFoo>

=item * Search CPAN

L<http://search.cpan.org/dist/NuFoo/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Mark Pitchless.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut
