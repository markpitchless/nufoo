package NuFoo::ExtJS::Preconf::Component::Builder;

=head1 NAME

NuFoo::ExtJS::Preconf::Component::Builder - Builds basic skelton for etending an ExtJS component.

=cut

use CLASS;
use Log::Any qw($log);
use Moose;
use MooseX::Method::Signatures;
use NuFoo::Core::Types qw(File Dir);

extends 'NuFoo::Core::Builder';

with 'NuFoo::Core::Role::TT',
    'NuFoo::Core::Role::Authorship',
    'NuFoo::Role::HTML',
    'NuFoo::Role::JS';

has class => (
    is            => "rw",
    isa           => "Str",
    required      => 1,
    documentation => qq{Name of the Javascript class.},
);

has class_file => (
    is            => "rw",
    isa           => File,
    coerce        => 1,
    lazy_build    => 1,
    documentation => qq{File to write the class to, relative to js_dir. Default is derived from class.},
);

method _build_class_file { $self->js_class2file($self->class); }

has extends => (
    is            => "rw",
    isa           => "Str",
    default       => "Ext.Component",
    documentation => qq{Ext class to extend. Must be a Ext.Component, which is the default.},
);

has xtype => (
    is            => "rw",
    isa           => "Str",
    lazy_build    => 1,
    documentation => qq{The xtype to register the new class with. Default is derived from class name.},
);

method _build_xtype {
    my $xtype = $self->class;
    $xtype =~ s/\.//;
    return lc $xtype;
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
method _build_t_file { [$self->t_dir, $self->class.".html" ]; }

has t_dir => (
    is         => "rw",
    isa        => File,
    coerce     => 1,
    lazy_build => 1,
    documentation => qq{Dir for HTML test files. Default is '<html_dir>/t'.},
);
method _build_t_dir { return [$self->html_dir, "t"]; }

has ext_base => (
    is            => "rw",
    isa           => "Str",
    default       => "../ext",
    documentation => qq{Base url to use for the ext code in the test file.},
);


method namespace {
    my $ns = $self->class;
    return "" unless $ns =~ /\./;
    $ns =~ s/\.(\w+)$//;
    return $ns;
}

method build {
    $self->tt_write( $self->class_file, "class.js.tt" ); 
    $self->tt_write( $self->t_file,     "test.js.tt"  ) if $self->test;
    my $help = "Don't forget to load this class in your index.html. e.g.\n"
        . '<script type="text/javascript" src="./' . $self->class_file
        . '"></script>';
    $log->notice($help);
}

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 SYNOPSIS

 nufoo ExtJS.Preconf.Component --class=CLASS [ATTRIBUTES] 

=head1 DESCRIPTION

Build pre-configured component skeleton.

=head1 ATTRIBUTES 

=over 4

=item class

=item extends

=item xtype

=back

=head1 EXAMPLES 

 nufoo ExtJS.Preconf.Component --class Hello

 nufoo ExtJS.Preconf.Component --class HelloGrid --extends Ext.data.GridPanel
 
 nufoo ExtJS.Preconf.Component --class HelloGrid --email mark@foo.com --author mda --extends Ext.grid.GridPanel

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
