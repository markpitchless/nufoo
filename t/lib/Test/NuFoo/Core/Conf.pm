package Test::NuFoo::Core::Conf;

use strict;
use warnings;

use base qw(Test::Class);
use FindBin qw($RealBin);
use Test::More;
use Test::Deep;

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

sub inherited : Test(5) {
    my $self = shift;
    my ($conf);

    $conf = NuFoo::Core::Conf->new( files => [
        "$RealBin/etc/config",
        "$RealBin/etc/config.user"
    ] );
    ok $conf, "Got a config object for etc/config, etc/config.user";
    is $conf->get('Perl.license'), "perl", "Got Perl.license";
    is $conf->get('Perl.Moose.license'), "perl",
        "Got Perl.Moose.license (inherited)";
    is $conf->get('Perl.Module.Starter.license'), "perl",
        "Got Perl.Module.Starter.license (inherited)";
    is $conf->get('Perl.Moose.Class.license'), "mit",
        "Got Perl.Class.license (overridden)";
}

sub get_all : Test(1) {
    my $self = shift;

    my $conf = NuFoo::Core::Conf->new( files => ["$RealBin/etc/config"] );
    my $all  = $conf->get_all('core');
    cmp_deeply $all, { force => 0, hello => "world" }, "get_all";
}

sub from_env : Test(2) {
    my $self = shift;
    my $conf = NuFoo::Core::Conf->new( files => [
        "$RealBin/etc/config",
        "$RealBin/etc/config.user"
    ] );

    is $conf->get("NuFoo.include"), "/home/me/extrafoo", "Got NuFoo.include";
    local $ENV{NUFOO_INCLUDE} = "OK";
    is $conf->get("NuFoo.include"), "OK", "Got NuFoo.include from ENV";
}

1;
