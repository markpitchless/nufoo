package NuFoo::Role::TT;

=head1 NAME

NuFoo::Role::TT - Role for builders to use Template Toolkit templates. 

=cut

use Moose::Role;
use NuFoo::Meta::Attribute::Trait::NoTT;
use Template;

requires 'home_dir', 'write_file';

has tt_template => ( is => "ro", isa => "Template", required => 1,
    traits  => ["NoGetopt"],
    lazy    => 1,
    builder => '_build_tt_template',
);

sub _build_tt_template {
    my $self = shift;
    my @include = $self->home_dir;
    foreach ($self->meta->linearized_isa) {
        next unless $_->meta->does_role("NuFoo::Role::TT");
        push @include, $_->home_dir;
    }
    my $tt   = Template->new({
        INCLUDE_PATH => \@include, 
    });
    return $tt;
}

sub tt_attribs {
    my $class = shift;
    grep {
        # Ready for when we add a specific trait for TT attributes.
        #$_->does("NuFoo::Meta::Attribute::Trait::TT")
        #    or
        $_->name !~ /^_/
    } grep {
        !$_->does('NuFoo::Meta::Attribute::Trait::NoTT')
    } $class->meta->get_all_attributes
}

sub tt_vars {
    my $self = shift;
    my $vars = {
        builder => $self,
        build   => $self,
    };
    foreach my $attr ($self->tt_attribs) {
        my $name = $attr->name;
        my $meth = $attr->get_read_method;
        $vars->{$name} = $self->$meth;
    } 
    return $vars;
}

sub tt_process {
    my $self = shift;
    my ($tmpl, $extra_vars) = @_;
    
    my $tt   = $self->tt_template;
    my $vars = $self->tt_vars;
    %$vars   = (%$vars, %$extra_vars) if $extra_vars;
    my $out  = "";
    $tt->process( $tmpl, $vars, \$out ) || die $tt->error, "\n";
    return $out;
}

sub tt_write {
    my $self = shift;
    my ($file,$tmpl,%args) = @_;
    $args{vars} ||= {};
    my $out  = $self->tt_process( $tmpl, $args{vars} );
    $self->write_file( $file, \$out );
}

1;
__END__

=head1 SYNOPSIS

 method build() {
    my $self = shift;

    $self->tt_write( 'index.html' => 'index.html.tt' );

    my $file = $self->compute_file_name;
    my $out  = $self->tt_process( 'hello.html.tt' );
    $self->write_file( $file => $out );
 }

=head1 DESCRIPTION

A role for builders to use that want to build using Template Toolkit. This
deals with setting the include path to include the builders home directory. So
just drop your templates into the same dir in lib as your builder main class
(ie the class that inherits from L<NuFoo::Builder> and call the L</tt_write>
method or L</tt_process> method.

The home dir of any parent classes that do this role also get added to the
include path in method dispatch order. This means when you inherit from a class
that does templating you also inheit it's template path, hence templates. You
can override templates with your own placed in your builder home dir. Because
of this authors are encouraged to split the templates into smaller includes that
provide useful points to override. Also please add a TEMPLATES section to the
docs.

By default all of you classes attributes that don't start with an _ will be
passed to the template as variables. You can add the trait C<NoTT> to an
attribute to stop it getting added.
See L<NuFoo::Meta::Attribute::Trait::NoTT>.

For even more control override L</tt_attribs> or L</tt_vars>.

=head1 ATTRIBUTES 

=head2 tt_template

The L<Template> object to use for processing. Default creates an object with
the builders and its parents home directories as the include path, so you don't
normally need to worry about this. If you want to change it then override
C<_build_tt>.

=head1 METHODS 

=head2 tt_write

 $self->tt_write( $file => $template );

Combine template processing and writing.

=head2 tt_process

 my $text  = $self->tt_process( 'hello.txt.tt' );
 $self->write_file( "hello.txt" => $out );

Process the template given as the first arg returning the result as a string.
L</tt_vars> is called to get data to pass to the template.

=head2 tt_vars

Return HashRef of data to parse to the template.

Adds this class as vars C<builder> and C<build> and then uses L</tt_attribs> to
work out what data to add, which defaults to all properties of this class whose
names don't start with an underscore. These are added to the hash by calling
their accessors.

Use C<override> or C<around> to add to the default vars, see
L<Moose::Manual::MethodModifiers> for details. e.g.

  override 'tt_vars' => sub {
    my $self = shift;
    my $vars = super();
    $vars->{hello} = "world";
    return $vars;
 }

or

 around 'tt_vars' => sub {
    my $orig = shift;
    my $self = shift;
    my $vars = $self->$orig(@_);
    $vars->{hello} = "world";
    return $vars;
 }


=head2 tt_attribs

Returns a list of the attributes (as meta objects) that should be added to the
template. Filters out attributes whose names start with underscore or have the
NoTT trait.

=head1 SEE ALSO

L<NuFoo>, L<NuFoo::Builder>, L<Template>, L<Moose>, L<perl>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.

See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

See L<NuFoo/COPYRIGHT & LICENSE>.

=cut
