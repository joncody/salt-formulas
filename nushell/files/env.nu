# ==============================================================================
# Nushell System Environment (/etc/nushell/env.nu)
# ==============================================================================

# 1. Dynamic /opt discovery for PATH
if ('/opt' | path exists) {
    let opt_bins = (glob /opt/*/{bin,sbin} | where ($it | path type) == 'dir' and not ($it starts-with '/opt/src/'))
    $env.PATH = ($env.PATH | split row (char esep) | prepend $opt_bins | uniq)
}

# 2. System-wide toolchain variables
$env.RUSTUP_HOME = "/opt/rust/rustup"
$env.GOBIN = "/opt/go/bin"
$env.GOPATH = $"($env.HOME)/.local/share/go"
$env.EDITOR = "hx"
$env.VISUAL = "hx"

# 3. Add user ZFS datasets and local bin paths to PATH
let user_paths = [
    $"($env.HOME)/bin"
    $"($env.HOME)/.cargo/bin"
    $"($env.HOME)/.local/bin"
]
$env.PATH = ($env.PATH | prepend ($user_paths | where ($it | path exists)) | uniq)
