package NuFoo::ExtJS::Preconf::Component::Builder;

=head1 NAME

NuFoo::ExtJS::Preconf::Component::Builder - Builds...

=cut

use CLASS;
use Log::Any qw($log);
use Moose;
use MooseX::Method::Signatures;
use NuFoo::Core::Types qw(File Dir);
use File::Spec::Functions qw(catdir);

extends 'NuFoo::Core::Builder';

with 'NuFoo::Core::Role::TT',
    'NuFoo::Core::Role::Authorship';

has class => (
    is            => "rw",
    isa           => "Str",
    required      => 1,
    documentation => qq{},
);

has class_file => (
    is            => "rw",
    isa           => File,
    coerce        => 1,
    lazy_build    => 1,
    documentation => qq{},
);

method _build_class_file {
    return [$self->js_lib_dir, $self->javascript_class2file($self->class)];
}

has js_lib_dir => (
    is            => "rw",
    isa           => Dir,
    coerce        => 1,
    lazy_build    => 1,
    documentation => qq{Directory for Javascript source files. Looks for suitable dir or uses current as default.},
);

method _build_js_lib_dir {
    foreach (qw(js htdocs/js)) {
        if (-d $_) {
            $log->info("Using local js lib dir '$_'");
            return $_
        }
    }
    return ".";
}

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

method namespace {
    my $ns = $self->class;
    return "" unless $ns =~ /\./;
    $ns =~ s/\.(\w+)$//;
    return $ns;
}

method javascript_class2file (Str $class) {
    return catdir(split(/\./, $class)).".js";
}

method build {
    $self->tt_write( $self->class_file, "class.js.tt" ); 
    my $help = "Don't forget to load this class in your index.html. e.g.\n"
        . '<script type="text/javascript" src="./' . $self->class_file
        . '"><script>';
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
 
 nufoo ExtJS.Preconf.Component --class HelloGrid --email mark@foo.com --author mda --extends Ext.data.GridPanel

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
