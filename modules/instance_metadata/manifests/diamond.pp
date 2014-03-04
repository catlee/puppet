class instance_metadata::diamond {
    include diamond
    file {
        "/usr/share/diamond/collectors/instance_metadata.py":
            source => "puppet:///modules/instance_metadata/instance_metadata_collector.py",
            owner  => "root",
            mode   => 0755;

        "/etc/diamond/collectors/instance_metadata.conf":
            source => "puppet:///modules/instance_metadata/instance_metadata_diamond.conf",
            owner  => "root",
            mode   => 0755;
    }
}
