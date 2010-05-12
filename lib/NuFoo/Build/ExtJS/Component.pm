package NuFoo::Build::ExtJS::Component;

=head1 NAME

NuFoo::Build::ExtJS::Component - Builds basic skelton for etending an ExtJS component.

=cut

use CLASS;
use Log::Any qw($log);
use Moose;
use MooseX::Method::Signatures;
use NuFoo::Types qw(File Dir);

extends 'NuFoo::Builder';

with 'NuFoo::Role::TT',
    'NuFoo::Role::Authorship',
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

has html_t_file => (
    is         => "rw",
    isa        => File,
    coerce     => 1,
    lazy_build => 1,
    documentation => qq{File to write test to when --test is set. Default is built from class name.},
);
method _build_html_t_file { [$self->html_t_dir, $self->class.".html" ]; }

has ext_base => (
    is            => "rw",
    isa           => "Str",
    default       => "../ext",
    documentation => qq{Base url to use for the ext code in the test file.},
);

has cls => (
    is            => "rw",
    isa           => "Str",
    lazy_build    => 1,
    documentation => qq{CSS class for the component. Default based on class name.},
);
method _build_cls { (my $class = $self->class) =~ s/\./-/g; "x-$class"; }

has iconCls => (
    is            => "rw",
    isa           => "Str",
    lazy_build    => 1,
    documentation => qq{CSS class for the component icon. Default based on class name.},
);
method _build_iconCls { (my $class = $self->class) =~ s/\./-/g; "x-$class-icon"; }

method namespace {
    my $ns = $self->class;
    return "" unless $ns =~ /\./;
    $ns =~ s/\.(\w+)$//;
    return $ns;
}

method build {
    $self->tt_write( $self->class_file,  "class.js.tt" );
    $self->tt_write( $self->html_t_file, "test.js.tt"  ) if $self->test;
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

 nufoo ExtJS.Component --class=CLASS [ATTRIBUTES]

=head1 DESCRIPTION

Build pre-configured component skeleton.

=head1 ATTRIBUTES

=over 4

=item class

=item extends

=item xtype

=back

=head1 EXAMPLES

 nufoo ExtJS.Component --class Hello

 nufoo ExtJS.Component --class HelloGrid --extends Ext.data.GridPanel

 nufoo ExtJS.Component --class HelloGrid --email mark@foo.com --author mda --extends Ext.grid.GridPanel

=head1 SEE ALSO

L<NuFoo>, L<NuFoo::Builder>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

See L<NuFoo>.

=cut