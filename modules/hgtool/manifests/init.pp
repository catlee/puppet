class hgtool {
    case $::operatingsystem {
        Darwin,CentOS: {
            file  {
                "/usr/local/bin/hgtool.py": 
                    source => "puppet:///modules/hgtool/hgtool.py",
                    owner => "$users::root::username",
                    group => "$users::root::group",
                    mode => 0755;
            }
        }
        default: {
            fail("Don't know where to put hgtool on this plaform")
        }
    }
}
