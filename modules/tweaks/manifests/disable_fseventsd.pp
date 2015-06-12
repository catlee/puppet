# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Disable OSX finder service
class tweaks::disable_fseventsd {
    file {
        "/.fseventsd":
            ensure => directory,
            recurse => true,
            owner => root,
            group => admin,
            mode => 0700;
        "/.fseventsd/no_log":
            contents => "";
    }
}
