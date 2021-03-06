package NuFoo::Conf;

=head1 NAME

NuFoo::Conf - Provides config file loading for the nufoo.  

=cut

our $VERSION = '0.01';

use Moose;
use MooseX::Method::Signatures;
use MooseX::Types::Path::Class qw(Dir File);
use NuFoo::Types qw(FileList);
use Config::IniFiles;
use Log::Any qw($log);

has files => (
    is         => "ro",
    isa        => FileList,
    coerce     => 1,
    required   => 1,
    lazy_build => 1,
);

has _conf => (
    is  => "rw",
    # Tied to a "Config::IniFiles"
    isa => "HashRef"
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

method load_file (File $file does coerce) {
    my %conf;
    my $parent = $self->_conf;
    $log->debug("Loading '$file'");
    $parent = tied %$parent if $parent;
    tie %conf, 'Config::IniFiles', (
        '-import' => $parent,
        -file     => "$file",
    );
    confess "Config loading: @Config::IniFiles::errors"
        if @Config::IniFiles::errors;
    $self->_conf(\%conf);
}

method get (Str $path) {
    my $conf = $self->_conf;
    my ($section, $name) = $path =~ m/
        ^
        (.*)
        \.      # 1. Everything before the last dot
        ([\w\d_]+)    # 2. Name after last dot
        $/x
    ;
    return unless $section && $name;

    if ( $section eq "NuFoo" ) {
        my $env_name = "NUFOO_" . uc($name);
        return $ENV{$env_name} if exists $ENV{$env_name}; 
    }
    
    return unless $conf; # No config loaded

    return $conf->{$section}{$name} if exists $conf->{$section}{$name};

    # Look for config in parent sections.
    my ($parent) = $section =~ /^(.*)\./;
    if ($parent) {
        my $val = $self->get( "$parent.$name" );
        return $val if defined $val;
    }

    # Check the all category
    return $conf->{"All"}{$name} if exists $conf->{"All"}{$name};

    return undef;
}

method get_all (Str $section) {
    my $conf = $self->_conf || return; # No config loaded
    my $out  = {};
    return unless exists $conf->{$section};
    return { %{$conf->{$section}} };
    my @names = keys %{$conf->{$section}};
    foreach (@names) {
        $out->{$_} = $conf->val( $section, $_ );
    }
    return $out;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
__END__

=head1 SYNOPSIS

 # Use default file list
 my $obj = NuFoo::Conf->new();
 
 # Use your own file list
 my $obj = NuFoo::Conf->new( files => ["./my/config.ini"] );

=head1 DESCRIPTION

Provides config file loading duties for the nufoo.

=head1 ATTRIBUTES 

=head2 files

ArrayRef of files to load config from, in the order of precedance, with later
files config overriding that of earlier.

=head1 METHODS 

=head2 get

Get a config item. e.g.

 my $force = $conf->get( 'NuFoo.force' );
 my @path  = $conf->get( 'NuFoo.include_path' );

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
