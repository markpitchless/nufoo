package NuFoo::NuFoo::Builder;

=head1 NAME

NuFoo::NuFoo::Builder - Create a new builder.

=cut

use CLASS;
use Moose;
use MooseX::Method::Signatures;
use Template;
use File::Path qw(make_path);
use File::Spec::Functions qw(splitpath);


extends 'NuFoo::Builder';

has name => ( is => "rw", isa => "Str", required => 1,
    documentation => qq{Name of the new builder},
);

has class_name => (
    is      => "rw",
    isa     => "Str",
    lazy    => 1,
    builder => '_build_class_name',
    documentation => qq{Class name of the builder. You do not normally set as it is derived from the name by default.},
);

has tt => ( is => "ro", isa => "Template", required => 1,
    traits  => ["NoGetopt"],
    lazy    => 1,
    builder => '_build_tt',
);

sub _build_class_name {
    my $self = shift;
    my $name = $self->name;
    $name =~ s/\./::/g;
    return "NuFoo::$name";
}

sub _build_tt {
    my $self = shift;
    my $tt = Template->new({
        INCLUDE_PATH => $self->home_dir,
    });
    return $tt;
}

sub build {
    my $self = shift;

    my $tt   = $self->tt;
    my $tmpl = "builder.tt";
    my $vars = $self->tt_vars;
    my $out  = "";
    $tt->process( $tmpl, $vars, \$out ) || die $tt->error, "\n";

    my $file = $self->class2file( $self->class_name );
    $self->write_file( $file, \$out );
}

method write_file (Str $file, Str|ScalarRef $content) {
    my (undef, $dir, $filename) = splitpath( $file );
    unless ( -d $dir ) {
        my @created = make_path($dir);
        foreach (@created) {
            print "Created directory $_\n";
        }
    }
    if ( -f $file ) {
        print "Skipped $file : Already exists\n";
    }
    else {
        open my $out, ">", $file or die "Failed to open $file to write : $!"; 
        print $out (ref $content ? $$content : $content);
        print "Created file $file\n";
    }
} 

method class2file (Str $name) {
    $name =~ s/::/\//g;
    $name . ".pm";
}

# Just use MooseX::Getopt attribs for now
sub tt_attribs { shift->_compute_getopt_attrs; }

sub tt_vars {
    my $self = shift;
    my $vars = {};
    foreach my $attr ($self->tt_attribs) {
        my $name = $attr->name;
        my $meth = $attr->get_read_method;
        $vars->{$name} = $self->$meth;
    } 
    return $vars;
}

CLASS->meta->make_immutable;

1;
