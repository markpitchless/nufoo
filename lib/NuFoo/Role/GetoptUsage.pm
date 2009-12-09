
package NuFoo::Role::GetoptUsage;

=head1 NAME

NuFoo::Role::GetoptUsage - Generate usage message from attribute meta.

=cut

use 5.010;
our $VERSION = '0.01';

use Moose::Role;
use MooseX::Method::Signatures;
use Term::ANSIColor;
use Term::ReadKey;
use Text::Wrap;

requires qw(_compute_getopt_attrs _get_cmd_flags_for_attr);

our %Colours = (
    flag    => ['yellow'],
    heading => ['bold'],
    default_value => ['magenta'],
);

BEGIN {
    # Thanks to Hans Dieter Pearcey for this. See Getopt::Long::Descriptive.
    # Grab prog name before someone decides to change it.
    my $prog_name;
    sub _prog_name { @_ ? ($prog_name = shift) : $prog_name }
    _prog_name(File::Basename::basename($0));
}

method _parse_usage_format ( ClassName|Object $self: Str $fmt ) {
    $fmt =~ s/%c/_prog_name()/ieg;
    $fmt =~ s/%%/%/g;
    # TODO - Be good to have a include that generates a list of the opts
    #        %r - required  %a - all
    $fmt =~ s/^(Usage:)/colored $Colours{heading}, "$1"/e;
    return $fmt;
}

method _usage_format (ClassName|Str $self:) { "Usage:\n    %c [OPTIONS]"; }

method getopt_usage( ClassName|Object $self: Bool :$no_headings? ) {
    my $headings = $no_headings ? 0 : 1;
    
    say $self->_parse_usage_format($self->_usage_format) if $headings;
    
    my @attrs = sort { $a->name cmp $b->name } $self->_compute_getopt_attrs;

    my $max_len = 0;
    my (@req_attrs, @opt_attrs);
    foreach (@attrs) {
        my $len  = length($_->name);
        $max_len = $len if $len > $max_len;
        if ( $_->is_required && !$_->has_default && !$_->has_builder ) {
            push @req_attrs, $_;
        }
        else {
            push @opt_attrs, $_;
        }
    }

    my ($w) = GetTerminalSize;
    local $Text::Wrap::columns = $w -1 || 72;
    say colored $Colours{heading}, "Required:" if $headings;
    $self->_getopt_attr_usage($_, max_len => $max_len ) foreach @req_attrs;
    say colored $Colours{heading}, "Optional:" if $headings;
    $self->_getopt_attr_usage($_, max_len => $max_len ) foreach @opt_attrs;
}

method _getopt_attr_usage ( ClassName|Object $self: Object $attr, Int :$max_len ) {
    my ( $flag, @aliases ) = $self->_get_cmd_flags_for_attr($attr);
    my $label = join " ", map {
        length($_) == 1 ? "-$_" : "--$_"
    } ($flag, @aliases);
    my $docs  = $attr->documentation || "";
    my $pad   = $max_len + 2 - length($label);
    my $def   = $attr->has_default ? $attr->default : "";
    $docs = "Default:".colored($Colours{default_value}, $def).". $docs"
        if $def && ! ref $def;
    my $col1 = "    $label";
    $col1 .= "".( " " x $pad );
    my $out = wrap($col1, (" " x ($max_len + 9)), " - $docs" );
    $out =~ s/(--?\w+)/colored $Colours{flag}, "$1"/ge;
    say $out;
}

no Moose::Role;

1;
__END__

=head1 SYNOPSIS

 use Moose;

 with 'MooseX::Getopt', 'NuFoo::Role::GetoptUsage';

 $self->getopt_usage;

=head1 DESCRIPTION

Role to use along with L<MooseX::Getopt> to provide a usage printing method
that inspects your classes meta information to build the messsage.

=head1 ATTRIBUTES 

=head1 METHODS 

=head2 getopt_usage( Bool :$no_headings )

Prints the usage message followed by a table of the options. Options are
printed required first, then optional.  These two sections get a heading unless
C<no_headers> arg is true.

=head1 SEE ALSO

L<perl>, L<Moose>, L<MooseX::Getopt>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2009 Mark Pitchless

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
