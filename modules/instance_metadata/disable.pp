class instance_metadata::diable {
    file {
        "/etc/init.d/instance_metadata":
            ensure => absent;
        "/etc/instance_metadata.json":
            ensure => absent;
        "/usr/local/bin/instance_metadata.py":
            ensure => absent;
    }
    service {
        "instance_metadata":
            ensure => absent;
    }
}
