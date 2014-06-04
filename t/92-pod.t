#	$Id: 92-pod.t 6 2014-06-02 21:38:27Z adam $

use strict;
use Test::More;

eval "use Test::Pod::Coverage 1.00";
plan skip_all => "Test::Pod::Coverage 1.00 required for testing POD coverage" if $@;
all_pod_coverage_ok();
