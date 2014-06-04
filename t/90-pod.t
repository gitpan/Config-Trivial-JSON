#	$Id: 90-pod.t 6 2014-06-02 21:38:27Z adam $

use strict;

my $run_tests;

BEGIN {
    $run_tests = eval { require Test::Pod; };
};

use Test::More;

if (! $run_tests ) {
    plan skip_all => 'Test::Pod not installed, skipping test.';
}
else {
    plan tests => 1;
}

Test::Pod::pod_file_ok("./lib/Config/Trivial/JSON.pm", "Valid POD file" );

