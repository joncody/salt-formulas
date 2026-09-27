# System-wide Nushell environment (/etc/nushell/env.nu)

# 1. Dynamic /opt discovery for PATH
if ('/opt' | path exists) {
    let opt_bins = (glob /opt/*/{bin,sbin} | where ($it | path type) == 'dir' and not ($it starts-with '/opt/src/'))
    $env.PATH = ($env.PATH | split row (char esep) | prepend $opt_bins | uniq)
}

# 2. Go Toolchain Workspace and Destination
$env.GOPATH = "/opt/go"
$env.GOBIN = "/opt/go/bin"

# Guarantee high-priority PATH for Go binaries
$env.PATH = ($env.PATH | prepend "/opt/go/bin" | uniq)
