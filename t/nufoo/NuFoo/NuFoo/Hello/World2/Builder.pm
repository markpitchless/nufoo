package NuFoo::NuFoo::Hello::World2::Builder;

use CLASS;
use Moose;

extends 'NuFoo::Core::Builder';

has who => ( is => "rw", isa => "Str", default => "World",
    documentation => qq{Who to say hello to.},
);

sub build {
    my $self = shift;
}

CLASS->meta->make_immutable;

1;
