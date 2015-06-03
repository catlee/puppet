# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
class mercurial::settings {
    case $::operatingsystem {
        CentOS, Ubuntu, Darwin: {
            $hgext_dir = "/usr/local/lib/hgext"
        }
        default: {
            fail("cannot install on $::operatingsystem")
        }
    }

    file {
        $hgext_dir:
            ensure => directory,
            owner => root,
            mode => 0755;
    }
}
