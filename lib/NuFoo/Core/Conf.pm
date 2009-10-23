package NuFoo::Core::Conf;

=head1 NAME

NuFoo::Core::Conf - Provides config file loading for the nufoo.  

=cut

our $VERSION = '0.01';

use Moose;
use MooseX::Method::Signatures;
use Config::IniFiles;

has files => (
    is         => "ro",
    isa        => "ArrayRef",
    required   => 1,
    lazy_build => 1,
);

has _conf => (
    is  => "rw",
    isa => "Config::IniFiles"
);

sub _build_files {
    my $self = shift;
    return [
        '/etc/nufoo/config',
        "$ENV{HOME}/.nufoo/config",
        "./.nufoo/config",
        "./nufoo/config",
    ];
}

method BUILD {
    my $conf;
    foreach my $file ( @{ $self->files } ) {
        next unless -f $file;
        $self->load_file($file);
    }
}

method load_file (Str $file) {
    my $conf = Config::IniFiles->new(
        '-import' => $self->_conf,
        -file     => $file,
    );
    confess "Config loading: @Config::IniFiles::errors"
        if @Config::IniFiles::errors;
    $self->_conf($conf) if $conf;
    return $conf;
}

method get (Str $path) {
    return unless $self->_conf; # No config loaded
    my ($section, $name) = $path =~ m/
        ^
        (.*)
        \.      # 1. Everything before the last dot
        ([\w\d_]+)    # 2. Name after last dot
        $/x
    ;
    return unless $section && $name;
    return $self->_conf->val( $section, $name );
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
__END__

=head1 SYNOPSIS

 # Use default file list
 my $obj = NuFoo::Core::Conf->new();
 
 # Use your own file list
 my $obj = NuFoo::Core::Conf->new( files => ["./my/config.ini"] );

=head1 DESCRIPTION

Provides config file loading duties for the nufoo.

=head1 ATTRIBUTES 

=head2 files

ArrayRef of files to load config from, in the order of precedance, with later
files config overriding that of earlier.

=head1 METHODS 

=head2 get

Get a config item. e.g.

 my $force = $conf->get( 'core.force' );
 my @path  = $conf->get( 'core.include_path' );

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