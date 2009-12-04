package NuFoo::ExtJS::Preconf::Application::Builder;

=head1 NAME

NuFoo::ExtJS::Preconf::Application::Builder - Builds an application skeleton
for an ExtJS application using Saki's pre configured component setup.

=cut

use CLASS;
use Moose;
use MooseX::Method::Signatures;
use Log::Any qw($log);
use NuFoo::Core::Types qw(DirName);

extends 'NuFoo::Core::Builder';

with 'NuFoo::Core::Role::TT',
    "NuFoo::Core::Role::Authorship",
    "NuFoo::Role::JS";

has name => (
    is            => "rw",
    isa           => "Str",
    required      => 1,
    documentation => qq{Name of the new application/project.},
);

has theme => (
    is            => "rw",
    isa           => "Str",
    documentation => qq{Name of theme file to include. Give with extension.},
);

has application_class => (
    is            => "rw",
    isa           => "Str",
    lazy_build    => 1,
    documentation => qq{Class for the main application. Default is to use name.},
);

has css_file_name => (
    is            => "rw",
    isa           => "Str",
    lazy_build    => 1,
    documentation => qq{Name of the css file for ext overrides. Default derived from name.},
);

method _build_dir { $self->name; }

method _build_application_class {
    return $self->name . ".Application";
}

method _build_css_file_name {
    my $name = $self->name;
    $name = lc($name) . "-ext.css";
}

method build {
    $self->nufoo->mkdir( ['css'] );
    $self->nufoo->mkdir( ['ext'] );
    $self->nufoo->mkdir( ['js'] );
    $self->nufoo->mkdir( ['img'] );
    $self->nufoo->mkdir( ['img', 'icon'] );
    $self->tt_write( "index.html", 'index.html.tt' );
    $self->tt_write($self->js_class2file($self->application_class), 'Application.js.tt');
    $self->tt_write( ["css", $self->css_file_name], 'application.css.tt' );

    my $dir = $self->nufoo->dir;
    $log->notice("You need to copy ext code into $dir/ext directory.");
}

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 SYNOPSIS

 $ nufoo ExtJS.Preconf.Application --name NAME [ATTRIBUTES] 

=head1 DESCRIPTION

Builds an application skeleton for an ExtJS application using Saki's pre
configured component setup.

=head1 ATTRIBUTES 

=over 4

=item name

=item author

=item email

=back

=head1 EXAMPLES 

 nufoo ExtJS.Preconf.Application --email hello@world.com --author=mda --name NuFoo

=head1 ACKNOWLEDGEMENTS

Many thanks to Saki for the preconf idea this is based on.

TODO - Links to tutorial.

=head1 SEE ALSO

L<NuFoo>, L<NuFoo::Core::Builder>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

Saki.

=head1 COPYRIGHT & LICENSE

See L<NuFoo>.

=cut
