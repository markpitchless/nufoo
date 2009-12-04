package NuFoo::Core::Cmd::Logger;
use Carp qw(croak confess);
use Log::Any::Adapter::Util qw(make_method);
use strict;
use warnings;
use Term::ANSIColor;
use base qw(Log::Any::Adapter::Base);

our $VERSION = '0.01';

our %LOG_LEVEL;
{
    my $num = 0;
    %LOG_LEVEL = map { ($_ => $num++) } Log::Any->logging_methods;
}

our %LEVEL_COLOR = (
    #debug     => ['blue'],
    info      => ['green'],
    notice    => ['magenta'],
    warning   => ['yellow'],
    error     => ['red'],
    critical  => ['red'],
    alert     => ['red'],
    emergency => ['red'],
);

sub init {
    my ($self) = @_;

    $self->{level} ||= 'info';
    $self->{use_color} = (-t STDOUT ? 1 : 0) if not defined $self->{use_color};

    confess 'must supply a valid level'
        unless exists $LOG_LEVEL{ $self->{level} };

    $self->{level_num} = $LOG_LEVEL{ $self->{level} };
}

# Log to the screen, checking is_$level 
#
foreach my $method ( Log::Any->logging_methods() ) {
    my $level = ucfirst $method;
    my $is_level = "is_$method";
    make_method( $method, sub {
        my ($self,$msg) = @_;
        return unless $self->$is_level;
        my $color = $self->{use_color} && $LEVEL_COLOR{$method};
        if ( $color ) {
            print colored $color, "$level\: $msg", "\n";
        }
        else {
            print "$level\: $msg", "\n";
        }
    });
}

# Detection methods. Check the level.
#
foreach my $method ( Log::Any->detection_methods() ) {
    my $level = substr( $method, 3 );
    make_method( $method, sub {
        my $self = shift;
        return $LOG_LEVEL{ $level } >= $self->{level_num} ? 1 : 0;
    });
}

1;

__END__

=pod

=head1 NAME

NuFoo::Core::Cmd::Logger - A Log::Any screen logger.

=head1 SYNOPSIS

    use NuFoo::Core::Cmd::Logger;
    Log::Any->set_adapter('+NuFoo::Core::Cmd::Logger', level => $level);

=head1 DESCRIPTION

This L<Log::Any|Log::Any> adapter logs to the screen, for use with a command
line app. There is a single required parameter, I<level>, which is the minimum
level to log at.

=head1 SEE ALSO

L<Log::Any|Log::Any>

=head1 AUTHOR

Mark Pitchless

=head1 COPYRIGHT & LICENSE

Copyright (C) 2009 Mark Pitchless, all rights reserved.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
