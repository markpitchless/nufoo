package NuFoo::Core::Types;

=head1 NAME

NuFoo::Core::Types - The NuFoo types library. 

=cut

our $VERSION = '0.01';

use MooseX::Types -declare => [qw(
    ArrayRefOfStr
    IncludeList
    File
    Dir
    EmailAddress
    PerlPackageName
    PerlPackageList
    PerlMooseAttributeSpec
    PerlMooseAttributeSpecList
    PerlLicense
    FileList
)];
use MooseX::Types::Path::Class;
use MooseX::Types::Moose qw( :all );
use Email::Valid;

# Needed for defining deep coercion
subtype ArrayRefOfStr, as ArrayRef[Str];

subtype IncludeList,
    as ArrayRef[Str];

coerce IncludeList,
    from Str,
    via { [ split(/:/, $_) ] };

# I just want to have the File and Dir from MooseX::Types::Path:Class exported
# by this mod. There must be an easier way?
subtype File,
    as 'Path::Class::File';

coerce File,
    from Str,      via { Path::Class::File->new($_) },
    from ArrayRef, via { Path::Class::File->new(@$_) },
;

subtype Dir,
    as 'Path::Class::Dir';

coerce Dir,
    from Str,      via { Path::Class::Dir->new($_) },
    from ArrayRef, via { Path::Class::Dir->new(@$_) },
;

subtype FileList,
    as ArrayRef[File],
;

coerce FileList,
    from ArrayRefOfStr,
    via { [ map { Path::Class::File->new($_) } @$_ ] }
;


subtype EmailAddress,
    as Str,
    where { Email::Valid->address($_) ? 1 : 0; },
    message { "The string ($_) is not a valid email address." };

subtype PerlPackageName,
    as Str,
    where { m/^\w+(::\w+)*$/ },
    message { "The string ($_) is not a valid package/class name" },
;

subtype PerlPackageList,
    as ArrayRef[PerlPackageName],
    message { "There is an invalid package/class name in ".join(", ", @$_) },
;

subtype PerlMooseAttributeSpec,
    as HashRef,
    where { defined $_->{name} && $_->{name} =~ m/^[\w_][\w\d_]*$/ },
    message { "Must have at least have a valid name" },
;

subtype PerlMooseAttributeSpecList,
    as ArrayRef[PerlMooseAttributeSpec];

sub str_to_moose_attribute_spec {
    my ($isa,$name,$def) = $_[0] =~ m/
        ^
        (?:(\w+):)?   # Optional type \1
        ([\w\d_]+)    # The attribute name \2
        (?:=(.*))?    # Optional default \3
        $
    /x;
    return unless $name;
    $isa ||= "Str";
    my $spec = { name => $name, isa => $isa, is => "rw" };
    $spec->{default} = $def if defined $def;
    return $spec;
}

coerce PerlMooseAttributeSpec,
    from Str,
    via { str_to_moose_attribute_spec($_); }
;

coerce PerlMooseAttributeSpecList,
    from ArrayRefOfStr,
    via { [ map { str_to_moose_attribute_spec($_); } @$_ ]; }
;

subtype PerlLicense,
    as Str,
    where   { m/perl|bsd|gpl|lgpl|mit/ },
    message { "Perl License must be one of perl, bsd, gpl, lgpl or mit" };


no Moose::Util::TypeConstraints;

1;
__END__

=head1 SYNOPSIS

 use Moose;
 use NuFoo::Core::Types qw( PerlPackageName );

 has class => ( is => 'rw', isa => PerlPackageName );

=head1 DESCRIPTION

The type library for L<NuFoo> using L<MooseX::Types>.

=head1 TYPES

=head2 PerlPackageName

A Str that is a valid perl package/class name.

=head1 ATTRIBUTES 

=head1 METHODS 

=head1 SEE ALSO

L<perl>, L<Moose>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.

See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

See L<NuFoo>.

=cut
