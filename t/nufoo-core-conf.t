#!perl

use FindBin qw($Bin);
use lib ("$Bin/lib");
use Test::NuFoo::Core::Conf;
Test::Class->runtests;
