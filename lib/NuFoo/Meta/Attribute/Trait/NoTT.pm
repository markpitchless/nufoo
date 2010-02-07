
package NuFoo::Meta::Attribute::Trait::NoTT;
use Moose::Role;

our $VERSION   = '0.1';

no Moose::Role;

# register this as a metaclass alias ...
package # stop confusing PAUSE
    Moose::Meta::Attribute::Custom::Trait::NoTT;
sub register_implementation { 'NuFoo::Meta::Attribute::Trait::NoTT' }

1;

__END__

=pod

=head1 NAME

NuFoo::Meta::Attribute::Trait::NoTT - Optional meta attribute trait to
stop sttributes getting passed to templates. 

=head1 SYNOPSIS

  package NuFoo::Some::Builder;
  use Moose;
  
  extends 'NuFoo::Builder';
  with 'NuFoo::Role::TT';
  
  has hello => (
      traits  => [ 'NoTT' ],  # do not pass to template
      is      => 'ro',
      isa     => 'Str',
  );

  # data is passed to the template as normal
  has 'data' => (
      is      => 'ro',
      isa     => 'Str',
  );

=head1 DESCRIPTION

This is a custom attribute metaclass trait which can be used to 
specify that a specific attribute should B<not> be passed to a
template when using L<NuFoo::Role::TT>.
All you need to do is specify the C<NoTT> metaclass trait.

  has 'foo' => (traits => [ 'NoGetopt', ... ], ... );

=head1 METHODS

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
See L<NuFoo/BUGS> for details of how to report bugs.

=head1 AUTHOR

Mark Pitchless, C<< <markpitchless at gmail.com> >>

=head1 COPYRIGHT AND LICENSE

See L<NuFoo>.

=cut
