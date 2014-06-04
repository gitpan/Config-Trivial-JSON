#   $Id: 61-kwalitee.t 6 2014-06-02 21:38:27Z adam $

use strict;
use Test::More;

BEGIN {
    eval { require Test::Kwalitee; };
    if ( $@ ) {
        plan skip_all => 'Test::Kwalitee not installed';
    }
    else {
        Test::Kwalitee->import();
    }
};
