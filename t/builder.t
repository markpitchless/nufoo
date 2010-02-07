#!/usr/bin/perl

use FindBin qw($Bin);
use lib ("$Bin/lib");
use Test::NuFoo::Builder;
Test::Class->runtests;
