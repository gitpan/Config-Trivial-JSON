#   $Id: 01-basic.t 12 2014-06-04 22:14:15Z adam $

use strict;
use Test::More tests => 4;

BEGIN { use_ok( 'Config::Trivial::JSON' ); }

is( $Config::Trivial::JSON::VERSION, '0.02_01', 'Version Check' );

my $config = Config::Trivial::JSON->new;
ok(defined $config, 'Object is defined' );
isa_ok( $config, 'Config::Trivial::JSON', 'Oject/Class Check' );

exit;
__END__
