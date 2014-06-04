#   $Id: 60-distribution.t 6 2014-06-02 21:38:27Z adam $

use Test::More;

BEGIN {
    eval { require Test::Distribution; };
    if( $@ ) {
        plan skip_all => 'Test::Distribution not installed, skipping test.';
    }
    else {
        import Test::Distribution;
    }
};
