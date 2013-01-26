# Make sure a tools repo is checked up and up to date at /tools/build-tools
class preflight::steps::tools {
    preflight::step {
        "checkout_tools":
            command => "checkout_tools.sh",
            level => "00";
    }
}
