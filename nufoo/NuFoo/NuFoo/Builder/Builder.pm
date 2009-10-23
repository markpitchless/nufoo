package NuFoo::NuFoo::Builder::Builder;

=head1 NAME

NuFoo::NuFoo::Builder::Builder - Create a new NuFoo builder.

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
use Template;

extends 'NuFoo::Core::Builder';

with 'NuFoo::Core::Role::TT';

has name => ( is => "rw", isa => "Str", required => 1,
    documentation => qq{Name of the new builder},
);

has class_name => (
    traits  => ["NoGetopt"],
    is      => "rw",
    isa     => "Str",
    lazy    => 1,
    builder => '_build_class_name',
    documentation => qq{Class name of the builder. You do not normally set as it is derived from the name by default.},
);

has 'with' => (
    is            => "rw",
    isa           => PerlPackageList,
    default       => sub { [] },
    documentation => qq{Roles this class does. Multiple allowed.},
);

has tt => (
    traits        => ['Getopt'],
    is            => "rw",
    isa           => Bool,
    default       => 0,
    documentation => qq{Setup builder for Template use.},
);

has 'has' => (
    is            => "rw",
    isa           => PerlMooseAttributeSpecList,
    default       => sub { [] },
    coerce        => 1,
    documentation => qq{Attributes for the class. Mutiple allowed.},
);

sub _build_class_name {
    my $self = shift;
    my $name = $self->name;
    $name =~ s/\./::/g;
    return "NuFoo::$name\::Builder";
}

method build () {
    if ( $self->tt ) {
        my $with = $self->with;
        unless ( "NuFoo::Core::Role::TT" ~~ @$with ) {
            $self->with( [ @$with, "NuFoo::Core::Role::TT"] );
        }
    }

    my $file = $self->class2file( $self->class_name );
    foreach (qw/nufoo .nufoo/) {
        if ( -d $_ ) {
            $log->info("Using local nufoo directory '$_'");
            $file = "$_/$file";
            last;
        }
    }
    $self->tt_write( $file => 'builder.tt' );
}

method class2file (Str $name) {
    $name =~ s/::/\//g;
    $name . ".pm";
}

CLASS->meta->make_immutable;

1;

__END__
=head1 SYNOPSIS

 nufoo NuFoo.Builder  ATTRIBUTES 
 
=head1 DESCRIPTION

Builds new NuFoo builders. 

=head1 ATTRIBUTES 

=over 4

=item name 

The name of the new builder in dot notation. Will be used to generate the
correct file and class names.

=item has

Attributes for the class.

=item with

List of roles to consume.

=item tt

Setup class for Template use. Includes the TT role.

=back

=head1 EXAMPLES

 nufoo NuFoo.Builder --name=Perl.Wizzbang

 nufoo NuFoo.Builder --name=My.Class

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
