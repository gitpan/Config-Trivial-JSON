#   $Id: Build.PL 9 2014-06-02 21:45:13Z adam $;

use Module::Build;

my $build = Module::Build->new(
    module_name => 'Config::Trivial::JSON',
    license     => 'lgpl3',
    requires    => {
        'perl'              => '5.010',
        'JSON::MaybeXS'     => '1.0',
        'Config::Trivial'   => '0.81',
    },
    configure_requires => {
        'Module::Build'    => '0.4',
    },
    build_requires => {
        'Module::Build' => '0.40',
        'IO::Capture'   => 0,
        'Test::Pod'     => 0,
        'Test::More'    => 0,
        'Pod::Coverage' => 0,
        'YAML'          => 0,
        'Test::Pod::Coverage'   => 0,
    },
);

$build->create_build_script;
