package NuFoo::Perl::Moose::Class::Builder;

=head1 NAME

NuFoo::Perl::Moose::Class::Builder - Builds Moose classes.

=cut

use CLASS;
use Moose;
use MooseX::Method::Signatures;
use MooseX::Types::Moose qw( :all );
use NuFoo::Core::Types qw(
    PerlPackageName
    PerlPackageList
    PerlMooseAttributeSpec
    PerlMooseAttributeSpecList
);
use Log::Any qw($log);

extends 'NuFoo::Core::Builder';

with 'NuFoo::Core::Role::TT';

has class => (
    is            => "rw",
    isa           => PerlPackageName,
    documentation => qq{The class name.},
);

has has => (
    is            => "rw",
    isa           => PerlMooseAttributeSpecList,
    default       => sub { [] },
    coerce        => 1,
    documentation => qq{Attributes for the class. Mutiple allowed.},
);

has extends => (
    is            => "rw",
    isa           => PerlPackageList,
    default       => sub { [] },
    documentation => qq{Class names the new class extends. Multiple allowed.},
);

has with => (
    is            => "rw",
    isa           => PerlPackageList,
    default       => sub { [] },
    documentation => qq{Roles this class does. Multiple allowed.},
);


method build {
    my $out  = $self->tt_process( 'class.pm.tt' );
    my $file = $self->class2file( $self->class );
    if ( -d "lib" ) {
        $log->info("Using local 'lib' directory");
        $file = "lib/$file";
    }
    $self->write_file( $file, \$out );
}

method class2file (Str $name) {
    $name =~ s/::/\//g;
    $name . ".pm";
}

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 SYNOPSIS

 $ nufoo Perl.Moose.Class --class=Hello::World 
 
 $ nufoo Perl.Moose.Class --class=Point --has=Int:x --has=Int:y
 
 $ nufoo Perl.Moose.Class --class=Point3D --extends=Point --has=Int:z

 $ nufoo Perl.Moose.Class --class=My::Cmd --with=MooseX::Getopt --has=Bool:force=1
 
=head1 DESCRIPTION

Builds L<Moose|Moose> classes.

=head1 ATTRIBUTES 

=head2 class

The package name for the new class.

=head2 has

List of attributes for the class. Each attribute is a hashref with a name
attribute to name the attribute the rest of the keys corrisonde to the
arguments passed to has when setting up a class.

The attribute can also be given as a string of the form:

 <type>:<name>=<default>

 type and default are optional.

=head2 extends

List of classes this class extends.

=head2 with

List of roles this class consumes.

=head1 METHODS 

=head1 SEE ALSO

L<NuFoo>, L<NuFoo::Core::Builder>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.

See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

See L<NuFoo>.

=cut
