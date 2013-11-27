package NuFoo::Build::OpenFrameworks::Starter;
use Moops;

class NuFoo::Build::OpenFrameworks::Starter 0.01
    extends NuFoo::Builder
    with NuFoo::Role::TT
    using Moose {
    use NuFoo::Types qw();
    use Log::Any qw($log);

    has name => (
        is       => "rw",
        isa      => Str,
        required => 1,
        #default  => "testApp",
        documentation => qq{Name for the new of app.},
    );

    has class => (
        is         => "rw",
        isa        => Str,
        lazy_build => 1,
        documentation => qq{Class name of the ofBaseApp sub class. Defaults to <name>App.},
    );

    has addons => (
        is         => "rw",
        isa        => ArrayRef[Str],
        documentation => qq{List of addons you want to use.},
    );

    has gitignore => (
        is         => "rw",
        isa        => Bool,
        default    => 0,
        documentation => qq{Add appropriate .gitignore files.},
    );

    method _build_class() { $self->name . "App"; }

    method build() {
        my $nufoo = $self->nufoo;
        my $name  = $self->name;
        my $class = $self->class;
        $nufoo->mkdir($name);
        $nufoo->mkdir("$name/src");
        $nufoo->mkdir("$name/bin");
        $nufoo->mkdir("$name/bin/data");
        $self->tt_write( "$name/Makefile"        => "Makefile.tt" );
        $self->tt_write( "$name/config.make"     => "config.make.tt" );
        $self->tt_write( "$name/addons.make"     => "addons.make.tt" );
        $self->tt_write( "$name/$name.cbp"       => "emptyExample.cbp.tt" );
        $self->tt_write( "$name/$name.workspace" => "emptyExample.workspace.tt" );
        $self->tt_write( "$name/src/main.cpp"    => "src/main.cpp.tt" );
        $self->tt_write( "$name/src/$class.cpp"  => "src/testApp.cpp.tt" );
        $self->tt_write( "$name/src/$class.h"    => "src/testApp.h.tt" );

        if ($self->gitignore) {
            $self->tt_write( "$name/.gitignore"          => "dot.gitignore.tt" );
            $self->tt_write( "$name/bin/.gitignore"      => "bin/dot.gitignore.tt" );
            $self->tt_write( "$name/bin/data/.gitignore" => "bin/data/dot.gitignore.tt" );
        }
    }
}

1;
__END__

=pod

=head1 NAME

NuFoo::Build::OpenFrameworks::Starter - Build a new openFrameworks application. 

=head1 DESCRIPTION

Buidl a new openFrameworks (oF) application. Should be run inside a
subdirectory of the apps folder within an open frameworks download.
Basically builds a copy of the emptyApp example using your own name.

Tested against linux 32bit, 0.62 release of open frameworks with code blocks.

L<http://www.openframeworks.cc/>

=head1 ATTRIBUTES

=head2 name

=head2 class

=head1 METHODS

=head1 EXAMPLES

 nufoo OpenFrameworks.Starter --name=helloWorld

=head1 SEE ALSO

L<NuFoo>, L<NuFoo::Builder>, L<perl>.

=head1 TODO

 * Support 64bit build.
 * Support the other build environments (Win, Mac).

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

Only tested using the Linux 32bit build.

=head1 ACKNOWLEDGEMENTS


=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 COPYRIGHT

Copyright 2011 Mark Pitchless

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

