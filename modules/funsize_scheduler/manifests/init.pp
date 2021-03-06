class funsize_scheduler {
    include ::config
    include funsize_scheduler::services
    include funsize_scheduler::settings
    include dirs::builds
    include packages::gcc
    include packages::libffi
    include packages::make
    include packages::mozilla::python27
    include users::builder

    python::virtualenv {
        "${funsize_scheduler::settings::root}":
            python   => "${packages::mozilla::python27::python}",
            require  => [
                Class["packages::mozilla::python27"],
                Class["packages::libffi"],
            ],
            user     => "${users::builder::username}",
            group    => "${users::builder::group}",
            packages => [
                "amqp==1.4.6",
                "anyjson==0.3.3",
                "argparse==1.2.1",
                "cffi==1.1.0",
                # PGPy depends on this _specific_ version of cryptography
                "cryptography==0.6",
                "ecdsa==0.10",
                "enum34==1.0.4",
                "funsize==0.46",
                "Jinja2==2.7.1",
                "kombu==3.0.26",
                "MarkupSafe==0.23",
                "more_itertools==2.2",
                "PGPy==0.3.0",
                "PyHawk-with-a-single-extra-commit==0.1.5",
                "PyYAML==3.10",
                "pycparser==2.13",
                "pycrypto==2.6.1",
                "python-jose==0.5.2",
                "redo==1.4.1",
                # Taskcluster pins requests 2.4.3, so we need to de the same,
                # even though we'd rather use a more up-to-date version.
                "requests==2.4.3",
                "singledispatch==3.4.0.3",
                "six==1.9.0",
                "slugid==1.0.6",
                "taskcluster==0.0.26",
                "wsgiref==0.1.2",
           ];
    }
}
