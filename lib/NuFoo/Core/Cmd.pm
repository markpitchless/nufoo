package NuFoo::Core::Cmd;

=head1 NAME

nufoo - Create new boiler plate code. 

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';
use 5.010;
use Moose;
use MooseX::Method::Signatures;
use Log::Any;
use NuFoo::Core::Cmd::Logger;
use Log::Any qw($log);
use Pod::Usage;

extends 'NuFoo';

with 'MooseX::Getopt';

# This activates use of Getopt::Long::Descriptive for usage (along with
# _usage_format below) to give the --help option.
# It is a bit restrictive, so should move to Pod::Usage at some point.
has help => ( is => 'rw', isa => 'Bool',
    documentation => "Display help message" );

has man => ( is => 'rw', isa => 'Bool',
    documentation => "Display manual" );

has debug => ( is => 'rw', isa => 'Bool', default => 0,
    documentation => "Output debugging messages." );

has quiet => ( is => 'rw', isa => 'Bool', default => 0,
    documentation => "Be quiet, only output errors messages." );

has include => (
    is            => 'rw',
    isa           => 'ArrayRef',
    auto_deref    => 1,
    predicate     => 'has_include',
    documentation => qq{Additional directories to search for builders. Give mutiple directories as multiple options.} );

sub _usage_format {
    return "usage: %c [OPTIONS] [BUILDER [BUILDER_OPTIONS]]";
}

before new_with_options => sub {
    Getopt::Long::Configure('pass_through'); 
};

method exit_error (Str $msg) {
    $log->error($msg);
    exit 1;
}

method usage_error (Str $msg, Int $verbose = 1) {
    $log->error($msg) if $msg;
    pod2usage(
        -verbose => $verbose,
        -input   => __FILE__,
    );
}

method builder_usage_error( Str|Object $class, Str $msg, Int $verbose = 99 ) {
    $class = blessed $class || $class;
    $log->error($msg) if $msg;
    pod2usage(
        -verbose  => $verbose,
        -input    => $class->home_dir . "/Builder.pm",
        -sections => "SYNOPSIS|ATTRIBUTES",
    );
}

method run() {
    my @argv = @{$self->extra_argv};

    my $level;
    $level = 'debug' if $self->debug;
    $level = 'error' if $self->quiet;
    $level ||= 'info';
    Log::Any->set_adapter('+NuFoo::Core::Cmd::Logger', level => $level);

    if ( $self->has_include) {
        $self->include_path( [ $self->include, $self->include_path ] );
    }

    my $name = shift @argv;
    $self->usage_error("",2) if $self->man && !$name;
    
    $self->usage_error("No builder name") if !$name || $name =~ m/^-/;

    my ($builder, $builder_class);
    eval { 
        $builder_class = $self->load_builder( $name );
        # XXX - This should really be $self->new_builder but we need to use
        # new_with_options, so must remember to emulate any logic from that
        # method. e.g. passing nufoo object.
        $builder = $builder_class->new_with_options( 
            argv  => \@argv, 
            nufoo => $self 
        );
        $self->builder_usage_error( $builder, "", 2 ) if $self->man;
        $builder->build
    };
    if ($@) {
        given($@) {
            when (/^Can't locate builder .*? in \@INC/) {
                $self->exit_error(
                    "Builder '$name' not found.\n(Searching: "
                    .join(' ',$self->include_path)
                    .")"
                );
            }
            when (
                /Attribute \((\w+)\) does not pass the type constraint because: (.*?) at/
            ) {
                $self->builder_usage_error(
                    $builder_class, "Invalid '$1' : $2"
                );
            }
            when (/Required option missing: (.*?)\n/) {
                $self->builder_usage_error(
                    $builder_class, "Required option missing: $1"
                );
            }
            when (/Unknown option: (.*?)\n/) {
                $self->builder_usage_error(
                    $builder_class, "Unknown option: $1"
                );
            }
            default {
                $log->error("Build failed: $@");
            }
        }
    }
}

1;
__END__

=head1 SYNOPSIS

 nufoo
 nufoo --man
 nufoo --man BUILDER

 nufoo [OPTIONS] [BUILDER] [BUILDER_OPTIONS]

=head1 DESCRIPTION

nufoo is a tool for creating new boiler plate files. E.g. new classes, html
pages etc. For example the following would create us a new Moose class. 
 
 nufoo Perl.Moose.Class --class=My::Foo

To get help on a particular builder, including what option it takes use --man
options with a builder name, e.g.

  nufoo --man Perl.Moose.Class

=head1 OPTIONS

=over 4

=item --include

Additional directories to search for builders in. Give more then once.

=item --quiet

Only show errors in log output.

=item --man

Display the manual page. With a builder name show the manual page for that
builder.

=item --debug

Show debug messages.

=back

=head1 SEE ALSO

L<NuFoo>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.

See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2009 Mark Pitchless.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
