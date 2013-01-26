define preflight::step($command, $level) {
    include preflight
    file {
        "/etc/preflight.d/$level-$command":
            content => template("preflight/$command.erb"),
            owner  => "root",
            group  => "root",
            mode => 755;
    }
}
