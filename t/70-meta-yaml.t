# $Id: 70-meta-yaml.t 6 2014-06-02 21:38:27Z adam $

use strict;
use Test;

my $run_tests;

BEGIN {
    $run_tests = eval { require YAML; };
    plan tests => 1
};

if (! $run_tests) {
    skip "YAML not installed, skipping test.";
    exit;
}

ok(YAML::LoadFile('./META.yml'));
