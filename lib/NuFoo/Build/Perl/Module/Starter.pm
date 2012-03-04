package NuFoo::Build::Perl::Module::Starter;

use CLASS;
use Moose;
use MooseX::Method::Signatures;
use Log::Any qw($log);
use Module::Starter;
use NuFoo::Types qw(PerlLicense EmailAddress);

extends 'NuFoo::Builder';

with 'NuFoo::Role::TT',
     'NuFoo::Role::Authorship';

has modules => (
    is            => "rw",
    isa           => "ArrayRef",
    required      => 1,
    documentation => qq{Module name (required, repeatable)},
);

has distro => (
    is            => "rw",
    isa           => "Str",
    documentation => qq{The distribution name (optional)},
);

has '+author' => ( required => 1 );
has '+email'  => ( required => 1 );

has license => (
    is            => "rw",
    isa           => PerlLicense,
    documentation => qq{License under which the module will be distributed (default is the same license as perl)},
);

has builder => (
    is            => "rw",
    isa           => "Str",
    default       => "ExtUtils::MakeMaker",
    documentation => qq{Build with 'ExtUtils::MakeMaker' or 'Module::Build'},
);


method build {
    my $config = $self->build_vars;
    $config->{class} ||= 'Module::Starter';
    $config->{force} = $self->nufoo->force ? 1 : 0;
    Module::Starter->create_distro( %$config );
    $log->info("Created distro");
}

CLASS->meta->make_immutable;
no Moose;

1;
__END__

=head1 NAME

Perl.Module.Starter - Uses module-starter to create new perl
distributions.

=head1 SYNOPSIS

 $ nufoo Perl.Module.Starter ATTRIBUTES 

=head1 DESCRIPTION

A thin wrapper around Andy Lester's excellent L<Module::Starter> package. The
options are passed onto module starter to do all the work. See it's docs for
details.

=head1 ATTRIBUTES 

=over 4

=item distro

=item author

=item email

=item license

=item builder

=item modules

Names of the initial modules to create. Must have at least one.

=back

=head1 EXAMPLES 

 nufoo Perl.Module.Starter --author='Mark Pitchless' --email='markpitchless@email.com' --module=My::Foo

=head1 SEE ALSO

L<Module::Starter>, L<NuFoo>, L<NuFoo::Builder>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

See L<NuFoo>.

=cut
