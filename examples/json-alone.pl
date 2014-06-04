#!/usr/bin/perl

#
#   Load some modules
#
use 5.010;
use strict;
use JSON::MaybeXS;

#
#   Initialise some variables
#
my $settings;
my $json_file = './json-example.json';

#
#   Create some settings
#
say 'Creating some data...';
$settings->{ 'animal' } = 'womble';
$settings->{ 'colour' } = 'red';

#
#   Encode into JSON
#
say 'Encoding data in JSON...';
my $json = encode_json( $settings );

#
#   Write JSON to disk
#
say 'Writing JSON to disk...';
open my $file, '>', $json_file or die "Unable to open $json_file for writing.\n";
print $file $json;
close $file;

#
#   Re-initialise the settings
#
say 'Re-initialising data...';
$settings = undef;
$json     = undef;
$file     = undef;

#
#   Load back from disk
#
say 'Loading JSON from disk...';
open $file, '<', $json_file or die "Unable to open $json_file for reading.\n";
while ( <$file> ) {
    $json .= $_;
}
close $file;

#
#   Decode from JSON
#
say 'Decoding JSON back into Perl data...';
$settings = decode_json( $json );
say " Animal: $settings->{ 'animal' }\n Colour: $settings->{ 'colour' }";

#
#   Clean up
#
say "Cleaning up, removing file $json_file...";
unlink $json_file;

