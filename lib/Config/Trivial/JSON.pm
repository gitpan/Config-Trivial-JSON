#   $Id: JSON.pm 12 2014-06-04 22:14:15Z adam $

package Config::Trivial::JSON;

use base qw( Config::Trivial );

use 5.010;
use strict;
use Carp;
use warnings;
use JSON::MaybeXS;

our $VERSION = '0.02_01';
my ( $_package, $_file ) = caller;

#
#   STORE
#

sub store {
    my $self = shift;
    my %args = @_;

    my $file = $args{'config_file'}
        || $self->{_json_file}
        || $self->{_config_file};

    if ( (   ( $self->{_self} )
          && ( ( $file =~ '\(eval ' ) || ( $file =~ 'base.pm' ) ) )
        || ( $_file eq $file )
        || ( $0     eq $file ) )
    {
        return $self->_raise_error(
            'Not allowed to store to the calling file.');
    }

    if ( -e $file ) {
        croak "ERROR: Insufficient permissions to write to: $file"
            unless ( -w $file );
        rename $file, $file . $self->{_backup_char}
            or croak "ERROR: Unable to rename $file.";
    }

    my $settings = $args{'configuration'} || $self->{_configuration};

    if ( ! ( $settings && ref $settings eq 'HASH') ) {
        return $self->_raise_error(
            q{Configuration object isn't a HASH reference.})
    };

    my $json_text = encode_json( $settings );
    if ( $json_text ) {
        open my $json_file, '>', $file or croak "Unable to store to $file";
        print $json_file $json_text;
        close $json_file;
    }
    else {
        croak 'Unable to encode Per structure into JSON';
    }

    return 1;
}

#
#   RETRIEVE
#

sub retrieve {
    my $self = shift;
    my $key  = shift;    # If there is a key, return only it's value
    my $retrieved_hash_ref;
    my $file;

    if ( $self->{_config_file} && $self->{_json_file} ) {
        if ( $self->{_config_file} eq $self->{_json_file} ) {
            $file = $self->{_config_file};
        }
        elsif ( ( stat $self->{_config_file} )[9]
            > ( stat $self->{_json_file} )[9] )
        {
            return $self->read($key) if $key;
            return $self->read;
        }
        else {
            $file = $self->{_json_file};
        }
    }
    else {
        if ( $self->{_json_file} ) {
            $file = $self->{_json_file};
        }
        else {
            no warnings qw( uninitialized );
            if ((      ( $self->{_self} )
                    && ( defined $self->{_config_file} )
                    && (  ( $self->{_config_file} =~ '\(eval ' )
                       || ( $self->{_config_file} =~ 'base.pm' ) )
                )
                || ( $_file eq $self->{_config_file} )
                || ( $0     eq $self->{_config_file} )
                )
            {
                return $self->_raise_error(
                    q{Can't retrieve store from the calling file.});
            }
            $file = $self->{_config_file};
        }
    }

    return unless $self->_check_file( $file );

    open my $json_file, '<', $file
        or croak "ERROR: Unable to open JSON file: $file";
    my $json_lines;
    while ( <$json_file> ) {
        $json_lines .= $_;
     };
    close $json_file;

    eval { $retrieved_hash_ref = decode_json( $json_lines ); };

    if ( $@ ) {
        return $self->_raise_error(
            qq{$@} )
    }

    if ( ! ( $retrieved_hash_ref && ref $retrieved_hash_ref eq 'HASH') ) {
        return $self->_raise_error(
            q{Retrieved object isn't a HASH reference.})
    };

    $self->{_configuration} = $retrieved_hash_ref;

    return $self->{_configuration}->{$key} if $key;
    return $self->{_configuration};
}

#
#   SET JSON FILE
#

sub set_json_file {
    my $self               = shift;
    my $configuration_file = shift;

    if ( $self->_check_file( $configuration_file ) ) {
        $self->{_json_file} = $configuration_file;
        $self->{_self}          = 0;
        if ( ( $self->{_config_file} =~ '\(eval ' )
                ||  ($self->{_config_file} =~ 'base.pm' ) ) {
            delete $self->{_config_file};
        }
        return $self;
    }
    else {
        return;
    }
}

1;

__END__

=head1 NAME

Config::Trivial::JSON - Very simple tool for reading and writing
very simple JSON configuration files

=head1 VERSION

This documentation refers to Config::Trivial::JSON version 0.01_01

=head1 SYNOPSIS

  use Config::Trivial::JSON;
  my $config = Config::Trivial::JSON->new(
    config_file => '/path/to/my/config.json' );
  my $settings = $config->retrieve;
  say "Setting Colour is:\t", $settings->{'colour'};
  $settings->{'new-item'} = "New Setting";
  $settings->store;

=head1 DESCRIPTION

Use this module when you want use "Yet Another" very simple, light
weight configuration file reader. The module extends Config::Trivial
by providing JSON Support. See those modules for more details.

Here Be Dragons - this software is very much ALPHA quality, patches
and feedback are very welcome.

=head1 SUBROUTINES/METHODS

=head2 store

The store method outputs a JSON representation of the configuration
rather than a plain text version that the write version would.

There are two optional parameters that can be passed, a file
name to use instead of the current one, and a reference of a
hash to write out instead of the currently loaded one.

  $config->store(
    file_name => "/path/to/somewhere/else",
    configuration => $settings);

The method returns true on success. If the file already exists
then it is backed up first. If the file cannot be
written to then it will die.

Configuration data passed by this method is only written to
file, it is not stored in the internal configuration object.
To store data in the internal use the set_configuration data
method. The option to pass a hash_ref in this method may
be removed in future versions.

If you do not specify a file name then the module will default to
writing to the calling file - which is obviously silly and it will
try to avoid doing this - hence the error message:
"Can't retrieve store from the calling file.".

=head2 retrieve

This is the analogue to read, only it reads data from a JSON file.

  $config->retrieve;

If both JSON and traditional text configuration files are set then
retrieve will use the JSON version in preference, but if the text
version is newer then that will be used instead. Thus you can easily
edit the text version and any code using this module will automatically
switch to using it.

=head2 set_json_file

If you want to explicitly set the file name of a JSON file
you may use this method. If you set a file name by both set_json_file
and set_config_file, then the retrieve method will "magically" decided
which to use. The read method will ignore any json settings.

=head1 CONFIG FORMAT

=head2 About The Configuration File Format

This module extends C<Config::Trivial> with optional support for using
JSON file format, rather than plain text files.

The format of the text files is as with C<Config::Trivial> and remains
unchanged, as this module inherits from that one. The json format
is offered so that modules can simply "retrieve" their configuration
without the use of any particular configuration module.

This module extends C<Config::Trivial> so that they can be used to quickly
read configuration in one format and convert to another.

=head1 DEPENDENCIES

At the moment the module only uses core modules, plus C<Config::Trivial>
and C<JSON::MaybeXS>. The test suite optionally uses C<POD::Coverage>,
C<Test::Pod::Coverage>, C<Test::Pod> and C<IO::Warnings> which will be
skipped if you do not have them.

=head1 BUGS AND LIMITATIONS

Patches very welcome... ;-)

=head1 MISC

=head2 History

See Changes file.

=head1 EXPORT

None.

=head1 AUTHOR

Adam Trickett, E<lt>atrickett@cpan.orgE<gt>

=head1 SEE ALSO

L<perl>, L<Config::Trivial>, L<JSON::MaybeXS>.

=head1 LICENSE AND COPYRIGHT

This version as C<Config::Trivial::JSON>, Copyright Adam John Trickett 2014

OSI Certified Open Source Software.
Free Software Foundation Free Software.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

=cut
