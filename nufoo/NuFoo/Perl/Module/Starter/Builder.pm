package NuFoo::Perl::Module::Starter::Builder;

=head1 NAME

NuFoo::Perl::Module::Starter::Builder - Builds...

=cut

use CLASS;
use Moose;
use MooseX::Method::Signatures;
use Log::Any qw($log);
use Module::Starter;

extends 'NuFoo::Core::Builder';

with 'NuFoo::Core::Role::TT';

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

has author => (
    is            => "rw",
    isa           => "Str",
    required      => 1,
    documentation => qq{Author's name (required)},
);

has email => (
    is            => "rw",
    isa           => "Str",
    required      => 1,
    documentation => qq{Author's email (required)},
);

has license => (
    is            => "rw",
    isa           => "Str",
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
}

sub build_attribs {
    my $class = shift;
    grep {
        # Ready for when we add a specific trait for Build attributes.
        #$_->does("NuFoo::Core::Meta::Attribute::Trait::Build")
        #    or
        $_->name !~ /^_/
    } grep {
        !$_->does('NuFoo::Core::Meta::Attribute::Trait::NoBuild')
    } $class->meta->get_all_attributes
}

sub build_vars {
    my $self = shift;
    my $vars = {};
    foreach my $attr ($self->build_attribs) {
        my $name = $attr->name;
        my $meth = $attr->get_read_method;
        $vars->{$name} = $self->$meth;
    } 
    return $vars;
}

CLASS->meta->make_immutable;
no Moose;

1;
__END__

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

L<Module::Starter>, L<NuFoo>, L<NuFoo::Core::Builder>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

See L<NuFoo>.

=cut
