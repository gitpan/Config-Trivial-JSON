#!/usr/bin/perl

#   $Id: example.pl 9 2014-06-02 21:45:13Z adam $

#
#   Load core modules
#
use 5.010;
use utf8;
use strict;
use warnings;
use Config::Trivial::JSON;

#   We're using utf8 in this file and the output
binmode STDOUT, ':utf8';

#   Test file
my $file   = './example.json';

#   Settings structure
my $settings;

#   Create config object
my $config = Config::Trivial::JSON->new( );

#   Create some setting values
$settings->{'book'}   = 'Shadow of the Apt';
$settings->{'colour'} = 'Red';
$settings->{'animal'} = 'Rabbit';

#   Store our settings on the filesystem
my $result = $config->store(
    config_file => $file,
    configuration => $settings );

#   Did it work?
if ( $result ) {
    say "$file was stored sucessfully.";
}
else {
    say $config->get_error();
    die "$file was not stored.\n";
};

#   Reset
$config   = undef;
$settings = undef;

#   Create a new config object
$config = Config::Trivial::JSON->new(
    config_file => $file
);

#   Get the settings back
$settings = $config->retrieve();

#   Write our settings out to the console
say "My book is $settings->{'book'}.";
say "Roses are $settings->{'colour'}.";
say "$settings->{'animal'} Pâté tastes nice.";

#   Clean up
say "Cleaning up, removing file $file...";
unlink $file;
