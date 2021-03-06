# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class packages::libc {
    case $::operatingsystem {
        CentOS: {
            case $::operatingsystemrelease {
                6.5: {
                    realize(Packages::Yumrepo['glibc'])
                    package {
                        'glibc':
                            ensure => "2.12-1.149.el6_6.5";
                    }
                }
                6.2: {
                    # still vulnerable - Bug 1126428
                }
                default: {
                    fail("unsupported CentOS version $::operatingsystemrelease")
                }
            }
        }

        Darwin: {
            # default version is fine
        }

        Ubuntu: {
            case $::operatingsystemrelease {
                12.04: {
                    realize(Packages::Aptrepo['eglibc'])
                    package {
                        "libc6":
                            ensure => '2.15-0ubuntu10.10';
                    }
                }
                default: {
                    # default version is fine
                }
            }
        }

        default: {
            fail("cannot install on $::operatingsystem")
        }
    }
}

