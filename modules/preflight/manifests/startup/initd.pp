# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
class preflight::startup::initd {
    file {
        "/etc/init.d/preflight":
            content => template("preflight/linux-initd-preflight.sh.erb"),
            owner  => "root",
            group  => "root",
            mode => 755;
    }

    service {
        "preflight":
            enable => true,
            require => [
                File['/etc/init.d/preflight'],
                File['/usr/local/bin/preflight.sh'],
            ];
    }
}
