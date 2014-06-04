#   $Id: 00-signature.t 6 2014-06-02 21:38:27Z adam $

use Test::More;
use strict;

BEGIN {

    if ( $ENV{SKIP_SIGNATURE_TEST} ) {
        plan( skip_all => 'Signature test skipped. Unset $ENV{SKIP_SIGNATURE_TEST} to activate test.' );
    }

    eval ' use Test::Signature; ';

    if ( $@ ) {
        plan( skip_all => 'Test::Signature not installed.' );
    }
    else {
        plan( tests => 1 );
    }
}
signature_ok();

