#!/usr/bin/perl -T

use strict;
use warnings;

use Test::More tests => 90;
use Test::Output;

use Log::Any qw($log);
use Log::Any::Adapter;

our @Levels = qw(debug info notice warning error critical alert emergency);

sub level_ok {
    my ($level,$tname) = @_;
    $tname   ||= "  $level";
    my $msg    = "hello $level";
    my $msg_ok = $log->_format_msg($msg, ucfirst($level))."\n";
    output_is(
        sub { $log->$level($msg) },
        "",      # stdout
        $msg_ok, # stderr
        $tname, 
    );
}

sub level_stdout_ok {
    my ($level,$tname) = @_;
    $tname   ||= "  $level";
    my $msg    = "hello $level";
    my $msg_ok = $log->_format_msg($msg, ucfirst($level))."\n";
    output_is(
        sub { $log->$level($msg) },
        $msg_ok, # stdout
        "",      # stderr
        $tname,
    );
}

# Default STDERR output
ok( Log::Any::Adapter->set( '+NuFoo::LogAnyAdapter', level => 'debug' ),
    "Set the adapter at debug" );
level_ok($_) foreach @Levels;

# STDOUT output
ok( Log::Any::Adapter->set( '+NuFoo::LogAnyAdapter', level => 'debug', stdout => 1 ),
    "Set the adapter at debug with stderr" );
level_stdout_ok($_) foreach @Levels;

# Level control
my @off_levels;
my @on_levels = @Levels;
while ( @on_levels ) {
    my $cur_level = $on_levels[0];
    ok( Log::Any::Adapter->set( '+NuFoo::LogAnyAdapter', level => $cur_level ),
        "Set the adapter at $cur_level" );

    foreach my $level (@off_levels) {
        output_is(
            sub { $log->$level("hello")},
            "", # stdout
            "", # stderr
            "  no $level"
        );
    }
    level_ok($_) foreach @on_levels;

    push @off_levels, shift @on_levels;
}
