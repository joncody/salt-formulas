# System-wide Nushell environment (/etc/nushell/env.nu)

# 1. Dynamic /opt discovery for PATH
if ('/opt' | path exists) {
    let opt_bins = (glob /opt/*/{bin,sbin} | where ($it | path type) == 'dir' and not ($it starts-with '/opt/src/'))
    $env.PATH = ($env.PATH | split row (char esep) | prepend $opt_bins | uniq)
}

# 2. Rust Toolchain: Share system-wide compiler components
$env.RUSTUP_HOME = "/opt/rust/rustup"

# 3. Go Toolchain: Binaries to /opt/go/bin, keep GOPATH separate from GOROOT
$env.GOBIN = "/opt/go/bin"
$env.GOPATH = $"($env.HOME)/.local/share/go"

# Guarantee high-priority PATH for Go binaries
$env.PATH = ($env.PATH | prepend "/opt/go/bin" | uniq)
