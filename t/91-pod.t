#	$Id: 91-pod.t 6 2014-06-02 21:38:27Z adam $

use strict;
use Test;

my $run_tests;

BEGIN {
    $run_tests = eval { require Pod::Coverage; };
    plan tests => 1
};

if (! $run_tests) {
    skip "Pod::Coverage not installed, skipping test.";
    exit;
}

my $pc = Pod::Coverage->new(package => 'Config::Trivial::JSON');
ok($pc->coverage == 1);
