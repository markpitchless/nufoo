package NuFoo::Core::Cmd;

=head1 NAME

NuFoo::Core::Cmd - Impliments the command line interface to NuFoo. 

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

extends 'NuFoo';

with 'MooseX::Getopt';

# This activates use of Getopt::Long::Descriptive for usage (along with
# _usage_format below) to give the --help option.
# It is a bit restrictive, so should move to Pod::Usage at some point.
has help => ( is => 'rw', isa => 'Bool',
    documentation => "Display help message" );

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

method run() {
    my @argv = @{$self->extra_argv};

    if ( $self->has_include) {
        $self->include_path( [ $self->include, $self->include_path ] );
    }

    my $level;
    $level = 'debug' if $self->debug;
    $level = 'error' if $self->quiet;
    $level ||= 'info';
    Log::Any->set_adapter('+NuFoo::Core::Cmd::Logger', level => $level);

    my $name = shift @argv;
    die "No builder name" if !$name || $name =~ m/^-/;

    my $builder_class = $self->load_builder( $name );
    die "Builder $name not found. (Searching: ".join(' ',$self->include_path).")"
        if !$builder_class;

    eval { 
        local @ARGV = @argv;
        my $builder = $builder_class->new_with_options;
        $builder->build
    };
    if ($@) {
        given($@) {
            when (
                /Attribute \((\w+)\) does not pass the type constraint because: (.*?) at/
            ) {
                my $name = $1;
                my $msg  = $2;
                $log->error("Invalid '$name' : $msg");
                # TODO pod2usage
            }
            when (/Required option missing: (.*?)\n/) {
                $log->error("Required option missing: $1");
                my $msg = $@;
                $msg =~ s/.*\n//; # Remove 1st line, the rest is usage.
                print $msg;
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

 #!/usr/bin/perl
 my $nufoo = NuFoo::Core::Cmd->new_with_options;
 $nufoo->run;

=head1 DESCRIPTION

=head1 METHODS 

=head2 run

Run the command line.

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
