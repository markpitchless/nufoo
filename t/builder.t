#!/usr/bin/perl

use FindBin qw($Bin);
use lib ("$Bin/lib");
use NuFoo::Test::Builder;
Test::Class->runtests;
