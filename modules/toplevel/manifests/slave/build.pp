class toplevel::slave::build inherits toplevel::slave {
    include dirs::builds
    include dirs::builds::slave
    include dirs::builds::hg-shared
    include dirs::builds::ccache
    include ntp::daemon
    include packages::mozilla-tools
    include tweaks::nofile
    include nrpe::check::buildbot
    include nrpe::check::ide_smart
    include nrpe::check::procs_regex
    include nrpe::check::child_procs_regex

    supervisord2::supervise {
        'Xvfb':
            command => "/usr/bin/Xvfb +extension :2",
            user => cltbld,
            autostart => true,
            autorestart => true;
        'metacity':
            command => '/usr/bin/metacity --display :2 --replace',
            user => cltbld,
            autostart => true,
            autorestart => true;
    }
}
