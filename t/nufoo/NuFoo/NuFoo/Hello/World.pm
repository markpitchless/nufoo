package NuFoo::NuFoo::Hello::World;

use CLASS;
use Moose;

extends 'NuFoo::Builder';

CLASS->meta->make_immutable;

1;
