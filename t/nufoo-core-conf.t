#!perl

use FindBin qw($Bin);
use lib ("$Bin/lib");
use Test::NuFoo::Conf;
Test::Class->runtests;
