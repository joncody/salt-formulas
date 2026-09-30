# /etc/nushell/env.nu
# System-wide Nushell environment configuration (Dual-Shell Architecture)

$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts and libraries
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts')
]

# Directories to search for plugin binaries
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins')
]

# 1. Discover isolated /opt tool binaries (excluding /opt/src build directories)
let opt_bins = if ('/opt' | path exists) {
    (glob '/opt/*/bin' | append (glob '/opt/*/sbin'))
    | where { |p| not ($p | str starts-with '/opt/src') }
} else {
    []
}

# 2. Discover user binary directories (including ~/.cargo/bin)
let user_bins = [
    ($env.HOME | path join "bin")
    ($env.HOME | path join ".local" "bin")
    ($env.HOME | path join ".cargo" "bin")
    ($env.HOME | path join ".deno" "bin")
] | where { |p| $p | path exists }

# 3. Discover optional Snap binaries
let snap_bins = if ('/snap/bin' | path exists) {
    ['/snap/bin']
} else {
    []
}

# 4. Construct unified PATH: User binaries > Isolated /opt tools > System paths > Snap
let base_path = if ($env.PATH | describe | str starts-with "list") {
    $env.PATH
} else {
    $env.PATH | split row (char esep)
}

$env.PATH = (
    $base_path
    | prepend $opt_bins
    | append $snap_bins
    | prepend $user_bins
    | uniq
)

# Default Editor & Tool Configuration
$env.EDITOR = "hx"
$env.VISUAL = "hx"
$env.BAT_CONFIG_PATH = "/etc/bat/config"

# Language Toolchains & Runtimes
$env.RUSTUP_HOME = "/opt/rust/rustup"
$env.GOBIN = "/opt/go/bin"
let xdg_data = ($env.XDG_DATA_HOME? | default ($env.HOME | path join ".local" "share"))
$env.GOPATH = ($xdg_data | path join "go")
$env.HELIX_RUNTIME = "/opt/helix/runtime"
$env.ZELLIJ_CONFIG_DIR = "/etc/zellij"

# Optional GnuPG Hardware Wallet
let trezor_path = ($env.HOME | path join ".gnupg" "trezor")
if ($trezor_path | path exists) {
    $env.GNUPGHOME = $trezor_path
}
