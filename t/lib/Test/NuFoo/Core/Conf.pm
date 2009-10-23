package Test::NuFoo::Core::Conf;

use strict;
use warnings;

use base qw(Test::Class);
use FindBin qw($RealBin);
use Test::More;

use NuFoo::Core::Conf;

sub simple : Test(5) {
    my $self = shift;
    my ($conf);

    $conf = NuFoo::Core::Conf->new( files => ["$RealBin/etc/not.here"] );
    ok $conf, "Got a config object for a missing file.";
    is $conf->get('core.hello'), undef, "Got undef core.hello from no config";
    
    $conf = NuFoo::Core::Conf->new( files => ["$RealBin/etc/config"] );
    ok $conf, "Got a config object for etc/config.";
    is $conf->get('core.hello'), "world", "Got core.hello from conf";
    is $conf->get('core.force'), 0, "Got core.force from conf";
}

sub stacked : Test(3) {
    my $self = shift;
    my ($conf);

    $conf = NuFoo::Core::Conf->new( files => [
        "$RealBin/etc/config",
        "$RealBin/etc/config.user"
    ] );
    ok $conf, "Got a config object for etc/config, etc/config.user";
    is $conf->get('core.hello'), "world", "Got core.hello from conf";
    is $conf->get('core.force'), 1, "Got core.force from conf (over ridden)";
}

1;
