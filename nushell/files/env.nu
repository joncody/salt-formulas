# ==============================================================================
# Nushell System Environment Setup (/etc/nushell/env.nu)
# ==============================================================================

# Default System Editor
$env.EDITOR = "hx"
$env.VISUAL = "hx"

# Rust & Go Toolchain configuration
$env.RUSTUP_HOME = "/opt/rust/rustup"
$env.GOBIN = "/opt/go/bin"
$env.GOPATH = (
    if "XDG_DATA_HOME" in $env {
        $"($env.XDG_DATA_HOME)/go"
    } else {
        $"($env.HOME)/.local/share/go"
    }
)
$env.HELIX_RUNTIME = "/opt/helix/runtime"

$env.ZELLIJ_CONFIG_DIR = "/etc/zellij"

# GnuPG Hardware Wallet (Trezor)
let trezor_gpg = $"($env.HOME)/.gnupg/trezor"
if ($trezor_gpg | path exists) {
    $env.GNUPGHOME = $trezor_gpg
}

# Dynamic /opt binary discovery
let opt_bins = if ("/opt" | path exists) {
    glob /opt/*/bin | append (glob /opt/*/sbin) | where not ($it | str starts-with "/opt/src")
} else {
    []
}

if ("/snap/bin" | path exists) {
    $env.PATH = ($env.PATH | split row (char esep) | append "/snap/bin")
}

# Explicit user binary directories (excludes ~/.cargo/bin so /opt/rust takes precedence)
let user_bins = [
    $"($env.HOME)/bin"
    $"($env.HOME)/.local/bin"
    $"($env.HOME)/.deno/bin"
] | where ($it | path exists)

# Prepend /opt tools and user directories to PATH
$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend $user_bins
    | prepend $opt_bins
    | uniq
)
