package NuFoo::LogAnyAdapter;
use strict;
use warnings;
use Carp qw(confess);
use Log::Any::Adapter::Util qw(make_method);
use Term::ANSIColor;
use base qw(Log::Any::Adapter::Base);

our $VERSION = '0.03';

our %LOG_LEVEL;
{
    my $num = 0;
    %LOG_LEVEL = map { ($_ => $num++) } Log::Any->logging_methods;
}

# Stop color leaking out and messing up the terminal
$Term::ANSIColor::EACHLINE = "\n";

our %LEVEL_COLOR = (
    debug     => ['blue'],
    info      => ['green'],
    notice    => ['green'],
    warning   => ['yellow'],
    error     => ['red'],
    critical  => ['bold red'],
    alert     => ['bold red'],
    emergency => ['bold red'],
);

# Set everything up. No API for changing settings so can pre calc eveything.
# Note the inherited new will have already stuffed the args into the $self hash.
sub init {
    my ($self) = @_;

    $self->{level}  ||= 'info';
    $self->{stdout} ||= 0;

    my $fh = $self->{_fh} ||= $self->{stdout} ? \*STDOUT : \*STDERR;
    $self->{use_color}      = (-t $fh ? 1 : 0) if not defined $self->{use_color};

    confess 'must supply a valid level'
        unless exists $LOG_LEVEL{ $self->{level} };

    $self->{level_num} = $LOG_LEVEL{ $self->{level} };
}

sub _format_msg {
    my $self = shift;
    my ($msg,$level) = @_;
    sprintf "%-8s $msg", "$level\:";
}

# Log to the screen, checking is_$level
#
foreach my $method ( Log::Any->logging_methods() ) {
    my $level    = ucfirst $method;
    my $is_level = "is_$method";

    make_method( $method, sub {
        my ($self,$msg) = @_;
        return unless $self->$is_level;

        my $color = $self->{use_color} && $LEVEL_COLOR{$method};
        my $fh    = $self->{_fh};
        $msg      = $self->_format_msg( $msg, $level );
        if ( $color ) {
            # Keep \n seperate to avoid term confusion with bg colors.
            print $fh colored( $color, $msg ), "\n";
        }
        else {
            print $fh $msg, "\n";
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

NuFoo::LogAnyAdapter - A Log::Any terminal logger used by L<NuFoo>.

=head1 VERSION

Version 0.03

=head1 SYNOPSIS

    use Log::Any qw($log);
    use Log::Any::Adapter;
    Log::Any::Adapter->set( '+NuFoo::LogAnyAdapter', level => 'debug' );

    $log->debug("Hello world");
    $log->info("Starting");
    $log->notice("Lots happening");
    $log->warning("Looking dodgey");
    $log->error("Bang!");
    $log->critical("Out of widgets");
    $log->alert("Please send help");
    $log->emergency("Their dead Dave");

=head1 DESCRIPTION

This L<Log::Any|Log::Any> adapter logs to the terminal screen, for use with
command line apps.

Default logs to STDERR, pass L</stdout> option to go to STDOUT. If it is
connected to a tty then the default is to log in colour, otherwise no colour
(so the logs wont be full of esc chars if redirected to a file). Colours used
are based on the log level. Control with the L</use_color> option.

Default log level is info, change with the L</level> option.

=head2 Changing colors

There is no formal mechanism for changing the colours used at the moment. They
are stored in C<%NuFoo::LogAngAdapter::LEVEL_COLOR>, with a key of log level
and a value of an array ref of color names to give to L<Term::ANSIColor>. So
just hack that to change the colors. This may well change in a future version.

=head1 OPTIONS

The following options can be passed into the C<Log::Any::Adapter->set> call.

=head2 level

The minimum log level name to log at. e.g. 'error'. Default is 'info'.

=head2 use_color

Whether to color the log output based on the level. Default will test to see if
we are connected to a tty and use color if we are, no color otherwise.

=head2 stdout

Set to true to log to STDOUT instead of the default of STDERR.

=head1 ENVIRONMENT

=over 4

=item ANSI_COLORS_DISABLED

Set to a true value to disable coloring of log output.

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.

See L<NuFoo/BUGS> for details of how to report bugs.

=head1 SEE ALSO

L<Log::Any|Log::Any>, L<Log::Any::Adapter|Log::Any::Adapter>,
L<Term::ANSIColor>.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2010 Mark Pitchless.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
