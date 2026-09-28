# ==============================================================================
# Nushell System Runtime Configuration (/etc/nushell/config.nu)
# ==============================================================================

# 1. Clean, minimalist prompt (Gruvbox Light palette)
def create_left_prompt [] {
    let dir = match (do -i { $env.PWD | path relative-to $nu.home-dir }) {
        null => $env.PWD
        '' => '~'
        $d => $"~/($d)"
    }
    $"(ansi cyan_bold)($dir)(ansi reset)\n(ansi green_bold)>(ansi reset) "
}

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| "" }

# 2. General settings
$env.config.show_banner = false
$env.config.edit_mode = "emacs"

# 3. Yazi directory switching wrapper (integrates navigation via 'y' command)
def --env y [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp | str trim)
    if $cwd != "" and $cwd != $env.PWD {
        cd $cwd
    }
    rm -fp $tmp
}
