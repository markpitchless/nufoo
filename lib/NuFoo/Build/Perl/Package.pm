package NuFoo::Build::Perl::Package;

=head1 NAME

NuFoo::Build::Perl::Package - Builds...

=cut

use CLASS;
use Log::Any qw($log);
use Moose;
use MooseX::Method::Signatures;
use NuFoo::Types qw(:all);
use Path::Class;

extends 'NuFoo::Builder';

with 'NuFoo::Role::TT';
with 'NuFoo::Role::Perl';
with 'NuFoo::Role::Authorship';
with 'NuFoo::Role::Licensing';

has package => (
    is            => "rw",
    isa           => PerlPackageName,
    required      => 1,
    documentation => qq{Package name},
);

has package_file => (
    is            => "rw",
    isa           => File,
    required      => 1,
    coerce        => 1,
    lazy_build    => 1,
    documentation => qq{File to write to. Default is to derive from package name},
);

method _build_package_file { $self->perl_package2file( $self->package ); }

method build {
    $self->tt_write( $self->package_file => 'package.pm.tt' );
}

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 DESCRIPTION

Builds perl packages, with all the normal pod sections setup.

=head1 ATTRIBUTES 

=over 4

=item package

=item file

=back

=head1 EXAMPLES 

 nufoo Perl.Package --package My::Foo

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
