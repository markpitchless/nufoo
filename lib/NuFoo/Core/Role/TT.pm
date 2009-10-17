package NuFoo::Core::Role::TT;

=head1 NAME

NuFoo::Core::Role::TT - Role for builders to use Template Toolkit templates. 

=cut

use Moose::Role;
use Template;

requires 'home_dir';

has tt => ( is => "ro", isa => "Template", required => 1,
    traits  => ["NoGetopt"],
    lazy    => 1,
    builder => '_build_tt',
);

sub _build_tt {
    my $self = shift;
    my $tt   = Template->new({
        INCLUDE_PATH => $self->home_dir,
    });
    return $tt;
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

sub tt_process {
    my $self = shift;
    my ($tmpl, $extra_vars) = @_;
    
    my $tt   = $self->tt;
    my $vars = $self->tt_vars;
    %$vars   = (%$vars, %$extra_vars) if $extra_vars;
    my $out  = "";
    $tt->process( $tmpl, $vars, \$out ) || die $tt->error, "\n";
    return $out;
}

1;
__END__

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES 

=head1 METHODS 

=head1 SEE ALSO

L<NuFoo>, L<NuFoo::Builder>, L<Moose>, L<perl>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.

See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

See L<NuFoo>.

=cut
