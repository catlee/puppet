# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Ensure we run preflight steps on this machine

class preflight::startup {
    anchor {
        'preflight::startup::begin': ;
        'preflight::startup::end': ;
    }

    # select an implementation class based on operating system
    $startuptype = $::operatingsystem ? {
        CentOS      => "initd",
    }
    Anchor['preflight::startup::begin'] ->
    class {
        "preflight::startup::$startuptype":
    } -> Anchor['preflight::startup::end']
}
