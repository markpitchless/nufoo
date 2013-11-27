package NuFoo::Role::Authorship;
use Moops;

=head1 NAME

NuFoo::Role::Authorship - Role for builders that want author information. 

=cut

role NuFoo::Role::Authorship using Moose {
    use NuFoo::Types qw( EmailAddress );

    has author => (
        is            => "rw",
        isa           => "Str",
        documentation => qq{Author's name},
    );

    has email => (
        is            => "rw",
        isa           => EmailAddress,
        documentation => qq{Author's email},
    );
}


1;
__END__

=head1 SYNOPSIS

 does "NuFoo::Role::Authorship";

=head1 DESCRIPTION

=head1 ATTRIBUTES 

=head2 author

=head2 email

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
