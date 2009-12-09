
package NuFoo::Role::GetoptUsage;

=head1 NAME

NuFoo::Role::GetoptUsage -  

=cut

our $VERSION = '0.01';

use Moose::Role;
use MooseX::Method::Signatures;
use 5.010;

requires qw(_compute_getopt_attrs _get_cmd_flags_for_attr);

# Thanks to Hans Dieter Pearcey for this. See Getopt::Long::Descriptive. 
my $prog_name;
sub _prog_name { @_ ? ($prog_name = shift) : $prog_name }

BEGIN {
  # grab this before someone decides to change it
  _prog_name(File::Basename::basename($0));
}

method getopt_usage( ClassName|Object $self: Bool :$no_headings ) {
    my $headings = $no_headings ? 0 : 1;
    
    say $self->_parse_usage_format($self->_usage_format) if $headings;
    
    my @attrs   = $self->_compute_getopt_attrs;
    my $max_len = 0;
    foreach (@attrs) {
        my $len = length($_->name);
        $max_len = $len if $len > $max_len;
    }

    say "  required:" if $headings;
    $self->_attr_usage($_, max_len => $max_len ) foreach
        grep { $_->is_required && !$_->has_default && !$_->has_builder }
        @attrs;
    say "  optional:" if $headings;
    $self->_attr_usage($_, max_len => $max_len ) foreach
        sort { $a->name cmp $b->name }
        grep { !($_->is_required && !$_->has_default && !$_->has_builder) }
        @attrs;
}

method _parse_usage_format ( ClassName|Object $self: Str $fmt ) {
    $fmt =~ s/%c/_prog_name()/ie;
    $fmt =~ s/%%/%/;
    # TODO - Be good to have a include that generates a list of the opts
    #        %r - required  %a - all
    return $fmt;
}

method _attr_usage ( ClassName|Object $self: Object $attr, Int :$max_len ) {
    my ( $flag, @aliases ) = $self->_get_cmd_flags_for_attr($attr);
    my $label = join " ", map { "--$_" } ($flag, @aliases);
    my $docs  = $attr->documentation || "";
    my $pad   = $max_len + 2 - length($label);
    my $def   = $attr->has_default ? $attr->default : "";
    $docs .= " Default: $def" if $def && ! ref $def;
    say "    $label".( " " x $pad )." - $docs";
}

no Moose::Role;

1;
__END__

=head1 SYNOPSIS

 use Moose;

 with 'NuFoo::Role::GetoptUsage';

=head1 DESCRIPTION

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

Copyright 2009 Mark Pitchless

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
