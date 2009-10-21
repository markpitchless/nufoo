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
    required      => 1,
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

has test_more => (
    is            => "rw",
    isa           => Bool,
    default       => 0,
    documentation => qq{Ceate a test file (Perl.Test.More) for this class.},
);

has test_class => (
    is            => "rw",
    isa           => Bool|PerlPackageName,
    default       => 0,
    documentation => qq{Ceate a test (Perl.Test.More) for this class.},
);

has test_class_name => (
    is            => "rw",
    isa           => PerlPackageName,
    lazy_build    => 1,
    documentation => qq{Class name for test if test_class is set. Default is to prefix Test:: to class name.},
);

has t_file => (
    is      => "rw",
    isa     => "Bool",
    default => 0,
    documentation => qq{Create a normal .t file to run the Test::Class when using test_class option.},
);

has t_file_name => (
    is        => "rw",
    isa       => "Str",
    predicate => "has_t_file_name",
    documentation => qq{Name for .t file when is using t_file option. Defaults to sensible name.},
);

sub _build_test_class_name {
    my $self = shift;
    return "Test::" . $self->class;
}

method build {
    my $out  = $self->tt_process( 'class.pm.tt' );
    my $file = $self->class2file( $self->class );
    if ( -d "lib" ) {
        $log->info("Using local 'lib' directory");
        $file = "lib/$file";
    }
    $self->write_file( $file, \$out );

    if ( $self->test_more ) {
        my $name = lc $self->class;
        $name =~ s/::/-/g;
        $self->nufoo->build( "Perl.Test.More", {
            name    => $name,
            uses_ok => [ $self->class ],
        } );
    }

    if ( $self->test_class ) {
        my $args = {
            class   => $self->test_class_name,
            uses    => [ $self->class ],
            t_file  => $self->t_file,
        };
        $args->{t_file_name} = $self->t_file_name if $self->has_t_file_name;
        $self->nufoo->build( "Perl.Test.Class", $args );
    }
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

 nufoo Perl.Moose.Class ATTRIBUTES 
 
=head1 DESCRIPTION

Builds L<Moose|Moose> classes.

=head1 ATTRIBUTES 

=over 4

=item class

The package name for the new class.

=item has

List of attributes for the class. Each attribute is a hashref with a name
attribute to name the attribute the rest of the keys corrisond to the
arguments passed to has when setting up a class.

The attribute can also be given as a string of the form:

 <type>:<name>=<default>

 type and default are optional.

=item extends

List of classes this class extends.

=item with

List of roles this class consumes.

=item test_more

Create a Perl.Test.More for this class.

=item test_class

Create a Perl.Test.Class for this class.

=item test_class_name

Class name for test if test_class is set. Default is to prefix Test:: to class name.

=item t_file

Create a normal .t file to run the Test::Class when using test_class option.

=item t_file_name

Name for .t file when is using t_file option. Defaults to sensible name.

=back

=head1 EXAMPLES

 nufoo Perl.Moose.Class --class=Hello::World 
 
 nufoo Perl.Moose.Class --class=Point --has=Int:x --has=Int:y

 nufoo Perl.Moose.Class --class=Point3D --extends=Point --has=Int:z

 nufoo Perl.Moose.Class --class=My::Cmd --with=MooseX::Getopt --has=Bool:force=1

 nufoo Perl.Moose.Class --class=User --has=name --test_class
 
 nufoo Perl.Moose.Class --class=User --has=name --test_more

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
