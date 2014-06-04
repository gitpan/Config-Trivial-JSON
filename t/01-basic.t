#   $Id: 01-basic.t 8 2014-06-02 21:45:02Z adam $

use strict;
use Test::More tests => 4;

BEGIN { use_ok( 'Config::Trivial::JSON' ); }

is( $Config::Trivial::JSON::VERSION, '0.01_01', 'Version Check' );

my $config = Config::Trivial::JSON->new;
ok(defined $config, 'Object is defined' );
isa_ok( $config, 'Config::Trivial::JSON', 'Oject/Class Check' );

exit;
__END__
