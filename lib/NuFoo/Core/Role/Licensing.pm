package NuFoo::Core::Role::Licensing;

=head1 NAME

NuFoo::Core::Role::Licensing - Role for builders that want licensing information. 

=cut

use Moose::Role;
use MooseX::Method::Signatures;
use MooseX::Types::Moose qw( ArrayRef );
use NuFoo::Core::Types qw( PerlLicenseList );
use Module::Starter::Simple;

has licenses => (
    is            => "rw",
    isa           => PerlLicenseList,
    coerce        => 1,
    predicate     => "has_licenses",
    documentation => qq{License(s) under which the code will be distributed.},
);

method license_blurb {
    return "" unless $self->has_licenses;
    my $blurb = "";
    my @licenses = @{$self->licenses};
    my $mapping = Module::Starter::Simple::_get_licenses_mapping({
        author => ($self->author || "")
    });
    foreach (@$mapping) {
        $blurb .= ($blurb ? "\n\n" : "") . $_->{blurb}
            if $_->{license} ~~ @licenses;
    }
    return $blurb;
}

1;
__END__

=head1 SYNOPSIS

 does "NuFoo::Core::Role::Licensing";

=head1 DESCRIPTION

=head1 ATTRIBUTES 

=head2 licensing 

=head1 METHODS 

=head2 license_blurb

=head1 SEE ALSO

L<NuFoo>, L<NuFoo::Core::Builder>, L<Moose>, L<perl>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

See L<NuFoo>.

=cut
