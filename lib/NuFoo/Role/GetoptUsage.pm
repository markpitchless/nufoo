
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
    flag          => ['yellow'],
    heading       => ['bold'],
    command       => ['green'],
    type          => ['magenta'],
    default_value => ['cyan'],
);

BEGIN {
    # Thanks to Hans Dieter Pearcey for this. See Getopt::Long::Descriptive.
    # Grab prog name before someone decides to change it.
    my $prog_name;
    sub _prog_name { @_ ? ($prog_name = shift) : $prog_name }
    _prog_name(File::Basename::basename($0));

    # Only use color when we are a terminal
    $ENV{ANSI_COLORS_DISABLED} = 1
        unless (-t STDOUT) && !exists $ENV{ANSI_COLORS_DISABLED};
}

method _parse_usage_format ( ClassName|Object $self: Str $fmt ) {
    $fmt =~ s/%c/colored $Colours{command}, _prog_name()/ieg;
    $fmt =~ s/%%/%/g;
    # TODO - Be good to have a include that generates a list of the opts
    #        %r - required  %a - all  %o - options
    $fmt =~ s/^(Usage:)/colored $Colours{heading}, "$1"/e;
    $self->_getopt_colourise(\$fmt);
    return $fmt;
}

method _usage_format (ClassName|Str $self:) { "Usage:\n    %c [OPTIONS]"; }

method getopt_usage( ClassName|Object $self: Bool :$no_headings?, Int :$exit? ) {
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
    say colored $Colours{heading}, "Required:" if $headings && @req_attrs;
    $self->_getopt_attr_usage($_, max_len => $max_len ) foreach @req_attrs;
    say colored $Colours{heading}, "Options:" if $headings && @opt_attrs;
    $self->_getopt_attr_usage($_, max_len => $max_len ) foreach @opt_attrs;

    exit $exit if defined $exit;
    return 1;
}

method _getopt_attr_usage ( ClassName|Object $self: Object $attr, Int :$max_len ) {
    my ( $flag, @aliases ) = $self->_get_cmd_flags_for_attr($attr);
    my $label = join " ", map {
        length($_) == 1 ? "-$_" : "--$_"
    } ($flag, @aliases);

    my $docs  = "";
    my $pad   = $max_len + 2 - length($label);
    my $def   = $attr->has_default ? $attr->default : "";
    (my $type = $attr->type_constraint) =~ s/(\w+::)*//g;
    $docs .= colored($Colours{type}, "$type. ") if $type;
    $docs .= colored($Colours{default_value}, "Default:$def").". "
        if $def && ! ref $def;
    $docs  .= $attr->documentation || "";
    #$docs  .= $attr->documentation ? "\t".$attr->documentation : "";

    my $col1 = "    $label";
    $col1 .= "".( " " x $pad );
    my $out = wrap($col1, (" " x ($max_len + 9)), " - $docs" );
    $self->_getopt_colourise(\$out);
    say $out;
}

method _getopt_colourise( ClassName|Object $self: Str|ScalarRef $out ) {
    my $str = ref $out ? $out : \$out;
    $$str =~ s/(--?\w+)/colored $Colours{flag}, "$1"/ge;
    return ref $out ? $out : $$str;
}

no Moose::Role;

1;
__END__

=head1 SYNOPSIS

 use Moose;

 with 'MooseX::Getopt::Basic', 'NuFoo::Role::GetoptUsage';

 $self->getopt_usage;

=head1 DESCRIPTION

Role to use along with L<MooseX::Getopt> to provide a usage printing method
that inspects your classes meta information to build the messsage.

=head1 ATTRIBUTES 

=head1 METHODS 

=head2 getopt_usage( Bool :$no_headings, Int :$exit )

Prints the usage message to stdout followed by a table of the options. Options
are printed required first, then optional.  These two sections get a heading
unless C<no_headings> arg is true.

If stdout is a tty usage message is colourised. Setting the env var
ANSI_COLORS_DISABLED will disable colour even on a tty.

If an exit arg is given and defined then this method will exit the program with
that exit code.

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
