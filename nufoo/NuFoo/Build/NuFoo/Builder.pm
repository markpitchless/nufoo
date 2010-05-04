package NuFoo::Build::NuFoo::Builder;

=head1 NAME

NuFoo::Build::NuFoo::Builder - Create a new NuFoo builder.

=cut

use CLASS;
use Moose;
use Moose::Autobox;
use MooseX::Method::Signatures;
use MooseX::Types::Moose qw( :all );
use NuFoo::Types qw();
use Path::Class qw(dir);
use Log::Any qw($log);

extends 'NuFoo::Build::Perl::Moose::Class';

has name => ( is => "rw", isa => Str, required => 1,
    documentation => qq{Name of the new builder},
);

has '+class' => (
    required => 1,
    lazy     => 1,
    builder  => '_build_class_name',
    documentation => qq{Class name of the builder. You do not normally set as it is derived from the name by default.},
);

has '+extends' => ( default => sub { ["NuFoo::Builder"] } );

has tt => (
    traits        => ['Getopt'],
    is            => "rw",
    isa           => Bool,
    default       => 0,
    documentation => qq{Setup builder for Template use.},
);

sub _build_class_name {
    my $self = shift;
    my $name = $self->name;
    $name =~ s/\./::/g;
    return "NuFoo::$name\::Builder";
}

method _build_perl_dir {
    my $dir = $self->nufoo->dir;
    foreach (qw/nufoo .nufoo/) {
        my $subdir = $dir->subdir($_);
        if ( -d $subdir ) {
            $log->info("Using local nufoo directory '$subdir'");
            return dir($_);
        }
    }
    return $self->SUPER::_build_perl_dir;
}

method build () {
    if ( $self->tt && !($self->class_with ~~ "NuFoo::Role::TT") ) {
        $self->class_with->unshift( "NuFoo::Role::TT" );
    }
    $self->uses->unshift(
        "NuFoo::Types qw()",
        'Log::Any qw($Log)'
    );
    $self->uses->unshift("MooseX::Method::Signatures") unless $self->declare;

    $self->SUPER::build(@_);
}

CLASS->meta->make_immutable;
no Moose;

1;

__END__

=pod

=head1 SYNOPSIS

 nufoo NuFoo.Builder --name NAME [ATTRIBUTES]
 
=head1 DESCRIPTION

Builds new NuFoo builder.

=head1 ATTRIBUTES 

See L<NuFoo::Build::Perl::Moose::Class|Perl.Moose.Class> for the base
attributes. Below are the extras this class adds.

=head2 name

The name of the new builder in dot notation. Will be used to generate the
correct file and class names.

=head2 tt

Setup class for Template use. Includes the TT role. Default is on.

=head1 EXAMPLES

 nufoo NuFoo.Builder --name=Perl.Wizzbang

 nufoo NuFoo.Builder --name=My.Class --extends NuFoo::Build::Perl::Moose::Class --has Bool:extras_docs

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
