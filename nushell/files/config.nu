# ==============================================================================
# Nushell System Configuration (/etc/nushell/config.nu)
# ==============================================================================

# 1. Minimal prompt
def create_left_prompt [] {
    let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $d => [ '~' $d ] | path join
    }
    $"([ansi cyan_bold]($dir)[ansi reset]) \n([ansi green_bold]❯[ansi reset]) "
}
$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| "" }

# 2. General settings
$env.config.show_banner = false

# 3. Yazi shell wrapper ('y' changes directory on exit, 'Q' cancels)
def --env y [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    ^yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp)
    if $cwd != "" and $cwd != $env.PWD {
        cd $cwd
    }
    rm -fp $tmp
}

# 4. Standard system aliases
alias h = hx
alias z = zellij
alias code = cd ~/code
