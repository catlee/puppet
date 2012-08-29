class packages::x11vnc {
    case $operatingsystem {
        CentOS: {
            package {
                "x11vnc":
                    ensure => latest;
            }
        }

        default: {
            fail("cannot install on $operatingsystem")
        }
    }
}
