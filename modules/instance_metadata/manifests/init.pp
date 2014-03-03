# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class instance_metadata {
    case $::fqdn {
        /.*\.releng\.(use1|usw2)\.mozilla\.com$/: {
            # AWS machines should fetch instance metadata and dump it in /etc/instance_metadata.json
            include packages::mozilla::py27_mercurial
            $python = $::packages::mozilla::python27::python

            file {
                "/usr/local/bin/instance_metadata.py":
                    owner  => "root",
                    mode   => 0755,
                    source => "puppet:///modules/instance_metadata/instance_metadata.py";

            }

            cron {
                require => File["/usr/local/bin/instance_metadata.py"],
                user    => root,
                command => "$python /usr/local/bin/instance_metadata.py -o /etc/instance_metadata.json",
                special => "reboot";
            }
        }
        default: {
            # Non-AWS machines should have empty metadata
            file {
                "/etc/instance_metadata.json":
                    owner    => root,
                    mode     => 0644,
                    contents => "{}";
            }
        }
    }
}
