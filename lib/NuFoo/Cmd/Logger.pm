package NuFoo::Cmd::Logger;
use Carp qw(croak);
use Log::Any::Util qw(make_method);
use strict;
use warnings;
use base qw(Log::Any::Adapter::Base);

our $VERSION = '0.01';

sub init {
    my ($self) = @_;

    #croak 'must supply level' unless defined( $self->{level} );
}

# Log to the screen 
#
foreach my $method ( Log::Any->logging_methods() ) {
    # method name is also the level
    my $level = ucfirst $method;
    make_method( $method, sub {
        my ($self,$msg) = @_;
        print "$level\: $msg", "\n";
    });
}

# Delegate detection methods to would_log
#
foreach my $method ( Log::Any->detection_methods() ) {
    my $level = substr( $method, 3 );
    make_method( $method, sub {
        return 1;
    });
}

1;

__END__

=pod

=head1 NAME

NuFoo::Cmd::Logger - A Log::Any screen logger.

=head1 SYNOPSIS

    use NuFoo::Cmd::Logger;
    Log::Any->set_adapter('+NuFoo::Cmd::Logger', level => $level);

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
