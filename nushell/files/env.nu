# ==============================================================================
# Nushell System Environment Setup (/etc/nushell/env.nu)
# ==============================================================================

# Rust & Go Toolchain configuration
$env.RUSTUP_HOME = "/opt/rust/rustup"
$env.GOBIN = "/opt/go/bin"
$env.GOPATH = (
    if "XDG_DATA_HOME" in $env {
        [$env.XDG_DATA_HOME "go"] | path join
    } else {
        [$env.HOME ".local" "share" "go"] | path join
    }
)
$env.HELIX_RUNTIME = "/opt/helix/runtime"

# Dynamic /opt binary discovery
let opt_bins = if ("/opt" | path exists) {
    glob /opt/*/bin | append (glob /opt/*/sbin) | where { |p| not ($p | str starts-with "/opt/src") }
} else {
    []
}

# Explicit user binary directories (excludes ~/.cargo/bin so /opt/rust takes precedence)
let user_bins = [
    ([$env.HOME "bin"] | path join)
    ([$env.HOME ".local" "bin"] | path join)
    ([$env.HOME ".deno" "bin"] | path join)
] | where { |p| $p | path exists }

# Prepend /opt tools and user directories to PATH
$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend $user_bins
    | prepend $opt_bins
    | uniq
)
