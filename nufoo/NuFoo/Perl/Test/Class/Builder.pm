package NuFoo::Perl::Test::Class::Builder;

use CLASS;
use Moose;
use MooseX::Method::Signatures;
use MooseX::Types::Moose qw( :all );
use NuFoo::Core::Types qw(
    PerlPackageName
    PerlPackageList
    PerlMooseAttributeSpec
    PerlMooseAttributeSpecList
);
use Log::Any qw($log);

extends 'NuFoo::Core::Builder';

with 'NuFoo::Core::Role::TT';

has class => (
    is            => "rw",
    isa           => PerlPackageName,
    required      => 1,
    documentation => qq{The class name.},
);

method build {
    my $file = $self->class2file( $self->class );
    my $out  = $self->tt_process( "class.pm.tt" );
    $self->write_file( $file, \$out );
}

method class2file (Str $name) {
    $name =~ s/::/\//g;
    $name . ".pm";
}

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 NAME

NuFoo::Perl::Test::Class::Builder - Builds Test::Class based tests.

=head1 SYNOPSIS

 $ nufoo Perl.Test.Class --class=CLASS [ATTRIBUTES] 

=head1 DESCRIPTION

Builds L<Test::Class> based tests.

=head1 ATTRIBUTES 

=over 4

=item class


=back

=head1 EXAMPLES 

 nufoo Perl.Test.Class --class=NuFoo::Test::Role::TT

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
