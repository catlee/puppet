# Run purge builds
class preflight::steps::purge {
    preflight::step {
        "purge_builds":
            command => "purge_builds.sh",
            level => "01";
    }
}
