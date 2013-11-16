package NuFoo::Cmd;

=head1 NAME

nufoo - Command line boilerplate generator for developers.

=head1 VERSION

Version 0.05

=cut

our $VERSION = '0.05';
use 5.010;
use Moose;
use MooseX::Method::Signatures;
use Log::Any;
use NuFoo::LogAnyAdapter;
use NuFoo::Types qw(IncludeList);
use Log::Any qw($log);
use Try::Tiny;

extends 'NuFoo';

with 'MooseX::Getopt::Usage',
     'MooseX::Getopt::Usage::Role::Man';

has '+help_flag' => ( documentation => "Show usage information. With a builder name show usage for that builder." );

has '+man' => ( documentation => "Display the manual page. With a builder name show the manual page for that builder." );

has debug => ( is => 'rw', isa => 'Bool', default => 0,
    documentation => "Output debugging messages." );

has quiet => ( is => 'rw', isa => 'Bool', default => 0,
    documentation => "Be quiet, only output error messages." );

has include => (
    is            => 'rw',
    isa           => IncludeList,
    coerce        => 1,
    auto_deref    => 1,
    predicate     => 'has_include',
    documentation => qq{Additional directories to search for builders. Give mutiple directories as multiple options.} );

has list => ( is => 'rw', isa => 'Bool', default => 0,
    documentation => "List availiable builders." );

# We need to handle --man and --help ourselves based on builder name.
sub getopt_usage_config { (
    auto_man   => 0,
    auto_usage => 0
); }

# Only pull out our options, leaving possible builder options.
before new_with_options => sub {
    Getopt::Long::Configure('pass_through'); 
};

method run() {
    my @argv = @{$self->extra_argv};

    my $level;
    $level = 'debug' if $self->debug;
    $level = 'error' if $self->quiet;
    $level ||= 'info';
    Log::Any->set_adapter( '+NuFoo::LogAnyAdapter', level => $level );

    if ( $self->has_include) {
        $self->include_path( [ $self->include, $self->include_path ] );
    }

    if ( $self->list ) {
        $self->show_list;
        return 0;
    }

    my $name = shift @argv;
    $self->getopt_usage( man => 1 ) if $self->man && !$name;
    $self->getopt_usage( exit => 0 ) if $self->help_flag && !$name;
    $self->getopt_usage( err => "No builder name", exit => 3 ) if !$name || $name =~ m/^-/;

    my ($builder, $builder_class);
    try {
        $builder_class = $self->load_builder( $name );
        $builder_class->getopt_usage( exit => 0 ) if $self->help_flag;
        $builder_class->getopt_usage( man => 1 ) if $self->man;

        # Construct the builder, we want unknown opt errors now.
        # Should possible be using new_builder if we go with that setup.
        Getopt::Long::Configure('no_pass_through');
        {
            local @ARGV = @argv;
            $builder = $builder_class->new_with_options( nufoo => $self );
        }
        $builder->build
    }
    catch {
        my $err = $_;
        given($err) {
            when (/^Can't locate builder .*? in \@INC/) {
                my $err =  "Builder '$name' not found.\n(Searching: "
                    .join(' ',$self->include_path).")";
                $self->getopt_usage( err => $err, exit => 4 );
            }
            when (
                /Attribute \((\w+)\) does not pass the type constraint because: (.*?) at/
            ) {
                $builder_class->getopt_usage(
                    err => "Invalid '$1' : $2",
                    exit => 5 );
            }
            when (/Required option missing: (.*?)\n/) {
                $builder_class->getopt_usage(
                    err => "Required option missing: $1",
                    exit => 6 );
            }
            when (/Unknown option: (.*?)\n/) {
                $builder_class->getopt_usage(
                    err => "Unknown option: $1",
                    exit => 7 );
            }
            default {
                $log->error("Build failed: $err");
            }
        }
        return 23;
    };

    # Got here with no errors, so all good, 0 status
    return 0;
}

method show_list {
    print map { "$_\n" } $self->builder_names;
}

1;
__END__

=head1 SYNOPSIS

    # Get help
    %c
    %c --man|--help
    %c --man|--help BUILDER
    %c BUILDER

    # List availiable builders
    %c --list

    # Build stuff
    %c [OPTIONS] BUILDER [BUILDER_OPTIONS]


=head1 DESCRIPTION

nufoo is a tool for creating new boiler plate files. E.g. new classes, html
pages etc. For example the following would create us a new Moose class. 
 
 nufoo Perl.Moose.Class --class=My::Foo

To get help on a particular builder, including what option it takes use --help
or --man for the full man page e.g.

  nufoo --help Perl.Moose.Class
  nufoo --man Perl.Moose.Class

=head1 SEE ALSO

L<NuFoo>.

=head1 BUGS

All software has bugs lurking in it, and this code is no exception.

Please report any bugs or feature requests via the github project at:

L<http://github.com/markpitchless/Log-Any-Adapter-Term>

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2009 Mark Pitchless.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.

=cut
