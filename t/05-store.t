#	$Id: 05-store.t 6 2014-06-02 21:38:27Z adam $

use strict;
use Test;
BEGIN { plan tests => 44 }

use Config::Trivial::JSON;

ok(1);

#
#	Basic Constructor (2-5)
#
ok(my $config = Config::Trivial::JSON->new(
	config_file => "./t/test.data"));			    # 2 Create Config object
ok($config->read);								    # 3 Read it in
ok($config->store(
	config_file => "./t/test2.json"));			    # 4 Write it out
ok(-e "./t/test2.json");						    # 5 Was written out

#
#	Create New (6-10)
#

$config = Config::Trivial::JSON->new();
my $data = {test => "orrinoco"};				    # New Data
ok($config->store(
	config_file => "./t/test3.json",		
	configuration => $data));					    # 6 Write it too
ok(-e "./t/test3.json");                            # 7 Test it's there 

$config = Config::Trivial::JSON->new();
ok($config->set_json_file("./t/test3.json"));       # 8 Manually set the JSON
$data = {
    test1 => "orrinoco",
    test => "womble"};          					# New Data
ok($config->store(configuration => $data));			# 9 Write it too
ok(-e "./t/test3.json");                            # 10 Test it's there
ok(-e "./t/test3.json~");                           # 11 Check it's updated the old file


#
#	Read things back (12-24)
#

ok($config = Config::Trivial::JSON->new(
    config_file => "./t/test2.json"));              # 12 Create Config object
ok($data = $config->retrieve);                      # 13 Get it back
ok($data->{test1}, "foo");                          # 14 check value
ok($data->{test3}, "baz");                          # 15 check value
ok($config->write);								    # 16 write it back (should make a backup)
ok(-e "./t/test2.json~");                           # 17 Check it's updated the old file

ok($config = Config::Trivial::JSON->new(
    config_file => "./t/test3.json"));              # 18 Create Config object
ok($config->retrieve("test"), "womble");            # 19 Retrive a single value
ok($config->retrieve("test1"), "orrinoco");         # 20 Retrive a single value

ok($config = Config::Trivial::JSON->new);           # 21 New empty setting 
ok($config->set_json_file("./t/test3.json"));       # 22 Manuall set the JSON
ok($config->{_json_file}, "./t/test3.json");        # 23 Set manually
ok($config->retrieve("test"), "womble");            # 24 Get the file using the JSON

#
#   Magic reading ... (25-34)
#

sleep (2);                                          # Ensure config file is younger than JSON 

$data = {test => "bulgaria"};                       # New Data
ok(! -e "./t/test4.data");                          # 25 Data file isn't there
ok($config->write(
    config_file => "./t/test4.data",
    configuration => $data));                       # 26 Write it
ok(-e "./t/test4.data");                            # 27 It's there now

ok($config = Config::Trivial::JSON->new(
    config_file => "./t/test.data"));               # 28 Create Config object (text version)
ok($config->set_json_file("./t/test3.json"));       # 29 Manually set the JSON
ok($config->retrieve("test"), "womble");            # 30 Get the file using the JSON
ok($config->set_config_file("./t/test4.data"));     # 31 Manually set the config file
ok($config->{_json_file}, "./t/test3.json");        # 32 The JSON file
ok($config->{_config_file}, "./t/test4.data");      # 33 The Config file
ok($config->retrieve("test"), "bulgaria");          # 34 Get the file using the JSON
ok($config->set_json_file("./t/test3.json"));       # 35 Manually set the JSON
ok($config->set_config_file("./t/test3.json"));     # 36 and config file to the same file
ok($config->retrieve("test"), "womble");            # 37 Get the file using the storefile
undef $data;
$data = $config->retrieve('');
ok ($data->{"test"}, "womble");                     # 38 Did the whole lot come back okay


#
#	Make sure we clean up (38-43)
#
ok(unlink("./t/test2.json", "./t/test2.json~", "./t/test3.json", "./t/test3.json~","./t/test4.data"), 5);
ok(! -e "./t/test2.json");						    # 39 Deleted test2.json okay
ok(! -e "./t/test2.json~");						    # 40 Deleted test2.json~ okay
ok(! -e "./t/test3.json");						    # 41 Deleted test3.json okay
ok(! -e "./t/test3.json~");						    # 42 Deleted test3.json okay
ok(! -e "./t/test4.data");						    # 43 Deleted test4.data okay

__DATA__

foo bar
