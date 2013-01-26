# The preflight module is for running things at boot
# If they fail, then the machine should alert and reboot and try again
class preflight {
    include preflight::startup
    case $::operatingsystem {
        CentOS: {
            file {
                "/usr/local/bin/preflight.sh":
                    source => "puppet:///modules/preflight/preflight.sh",
                    owner => "$users::root::username",
                    group => "$users::root::group",
                    mode => 0755;
                "/etc/preflight.d":
                    ensure => directory,
                    owner => "$users::root::username",
                    group => "$users::root::group",
                    mode => 0755;
            }
        }
        default: {
            fail("Don't know how to handle $::operatingsystem")
        }
    }
}
