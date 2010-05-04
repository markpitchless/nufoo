package NuFoo::Build::Perl::Class::Plain;

=head1 NAME

NuFoo::Build::Perl::Class::Plain - Builds plain old perl classes.

=cut

use CLASS;
use Log::Any qw($log);
use Moose;
use MooseX::Method::Signatures;
use NuFoo::Types qw( PerlPackageName );

extends 'NuFoo::Build::Perl::Package';

# Moose wont let us lazy_build here. Not allowed to change predicate or clearer
#has '+package' => ( lazy_build => 1 );
has '+package' => ( lazy => 1, builder => '_build_package' );
method _build_package { $self->class; }

has class => (
    is            => "rw",
    isa           => PerlPackageName,
    required      => 1,
    documentation => qq{The new class name. Used to derive the file to write.},
);

# No build method as we just override some templates.

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 SYNOPSIS

 nufoo Perl.Class.Plain --class CLASS [ATTRIBUTES] 

=head1 DESCRIPTION

Builds plain old perl classes.

=head1 ATTRIBUTES 

=over 4

=item class


The class name. Used to derive the file name.

=back

=head1 EXAMPLES 

 nufoo Perl.Class.Plain --class My::Foo

=head1 SEE ALSO

L<NuFoo>, L<NuFoo::Perl::Package>, L<NuFoo::Builder>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

See L<NuFoo>.

=cut
