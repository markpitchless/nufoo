package NuFoo::ExtJS::Preconf::Grid::Builder;

=head1 NAME

NuFoo::ExtJS::Preconf::Grid::Builder - Builds...

=cut

use CLASS;
use Log::Any qw($log);
use Moose;
use MooseX::Method::Signatures;
use NuFoo::Core::Types qw(File Dir);

extends 'NuFoo::ExtJS::Preconf::Component::Builder';

has '+extends' => ( default => "Ext.grid.GridPanel");

has html_dir => (
    is            => "rw",
    isa           => Dir,
    coerce        => 1,
    lazy_build    => 1,
    documentation => qq{Directory for HTML files. Looks for suitable dir or uses current as default.},
);

method _build_html_dir {
    foreach (qw(htdocs www)) {
        if (-d $_) {
            $log->info("Using local html dir '$_'");
            return $_
        }
    }
    return ".";
}

has test => (
    is         => "rw",
    isa        => "Bool",
    default    => 1,
    documentation => qq{True to create a test file.},
);

has t_file => (
    is         => "rw",
    isa        => File,
    coerce     => 1,
    lazy_build => 1,
    documentation => qq{File to write test to when --test is set. Default is built from class name.},
);

method _build_t_file {
    return [$self->html_dir, "t", $self->class.".html" ];
}

# class-extends.js.tt
method build {
    $self->SUPER::build(@_); 
    $self->tt_write( $self->t_file, "test.js.tt" ) if $self->test;
}

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 SYNOPSIS

 nufoo ExtJS.Preconf.Grid [ATTRIBUTES] 

=head1 DESCRIPTION

Builds...

=head1 ATTRIBUTES 

=over 4


=back

=head1 EXAMPLES 

 nufoo ExtJS.Preconf.Grid

=head1 SEE ALSO

L<NuFoo>, L<NuFoo::Core::Builder>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

See L<NuFoo>.

=cut
