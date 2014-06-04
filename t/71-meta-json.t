# $Id: 71-meta-json.t 6 2014-06-02 21:38:27Z adam $

use Test::More;

eval "use Test::CPAN::Meta::JSON";
plan skip_all => "Test::CPAN::Meta::JSON required for testing META.json" if $@;
meta_json_ok();
