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
    "NuFoo::Core::Role::Authorship";

has name => (
    is            => "rw",
    isa           => "Str",
    lazy_build    => 1,
    documentation => qq{Name of the new application/project.},
);

has dir => (
    is            => "rw",
    isa           => DirName,
    lazy_build    => 1,
    documentation => qq{Top level directory name to contain project. Uses name as default.},
);

has theme => (
    is            => "rw",
    isa           => "Str",
    documentation => qq{Name of theme file to include. Give with extension.},
);

method _build_name {
    return "ExtProject";
}

method _build_dir {
    if ( $self->has_name ) {
        return $self->name;
    }
    return "ExtProject";
}

method build {
    my $dir = $self->dir;
    $self->nufoo->mkdir( [$dir, 'css'] );
    $self->nufoo->mkdir( [$dir, 'ext'] );
    $self->nufoo->mkdir( [$dir, 'js'] );
    $self->nufoo->mkdir( [$dir, 'img'] );
    $self->nufoo->mkdir( [$dir, 'img', 'icon'] );
    $self->tt_write( [$dir, "index.html"], 'index.html.tt' );
    $self->tt_write( [$dir, "js", "Application.js"], 'Application.js.tt' );
    $self->tt_write( [$dir, "css", "application.css"], 'application.css.tt' );
}

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 SYNOPSIS

 $ nufoo ExtJS.Preconf.Application ATTRIBUTES 

=head1 DESCRIPTION

Builds an application skeleton for an ExtJS application using Saki's pre
configured component setup.

=head1 ATTRIBUTES 

=over 4

=item name


=back

=head1 EXAMPLES 

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
