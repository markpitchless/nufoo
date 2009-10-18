package NuFoo::NuFoo::Builder::Builder;

=head1 NAME

NuFoo::NuFoo::Builder::Builder - Create a new NuFoo builder.

=cut

use CLASS;
use Moose;
use MooseX::Method::Signatures;
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

has attributes => (
    is            => "rw",
    isa           => "ArrayRef",
    documentation => qq{Add attributes to the new builder. Give more than once.},
);

sub _build_class_name {
    my $self = shift;
    my $name = $self->name;
    $name =~ s/\./::/g;
    return "NuFoo::$name\::Builder";
}

method build () {
    my $file = $self->class2file( $self->class_name );
    foreach (qw/nufoo .nufoo/) {
        if ( -d $_ ) {
            $log->info("Using local nufoo directory '$_'");
            $file = "$_/$file";
            last;
        }
    }
    my $out = $self->tt_process( "builder.tt" );
    $self->write_file( $file, \$out );
}

method class2file (Str $name) {
    $name =~ s/::/\//g;
    $name . ".pm";
}

CLASS->meta->make_immutable;

1;
