# Dynamic environment setup for tools installed in /opt
if [ -d "/opt" ]; then

    # 1. PATH (bin & sbin) - Prepend so isolated /opt tools take precedence
    for dir in $(find /opt -mindepth 1 -maxdepth 2 -type d \( -name bin -o -name sbin \) ! -path '/opt/src/*' 2>/dev/null); do
        case ":$PATH:" in
            *":$dir:"*) ;;
            *) export PATH="$dir:$PATH" ;;
        esac
    done

    # 2. CPATH (include headers for compiling)
    for dir in $(find /opt -mindepth 1 -maxdepth 2 -type d -name include ! -path '/opt/src/*' 2>/dev/null); do
        case ":$CPATH:" in
            *":$dir:"*) ;;
            *) export CPATH="${dir}${CPATH:+:$CPATH}" ;;
        esac
    done

    # 3. PKG_CONFIG_PATH (pkgconfig metadata)
    for dir in $(find /opt -mindepth 1 -maxdepth 3 -type d -name pkgconfig ! -path '/opt/src/*' 2>/dev/null); do
        case ":$PKG_CONFIG_PATH:" in
            *":$dir:"*) ;;
            *) export PKG_CONFIG_PATH="${dir}${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}" ;;
        esac
    done

fi

# Ensure /snap/bin is included if snapd is present
if [ -d "/snap/bin" ]; then
    case ":$PATH:" in
        *":/snap/bin:"*) ;;
        *) export PATH="$PATH:/snap/bin" ;;
    esac
fi

# Dynamic user binary catch-all (explicitly avoid globbing ~/.cargo/bin)
for dir in "$HOME/bin" "$HOME/.local/bin" "$HOME/.deno/bin"; do
    if [ -d "$dir" ]; then
        case ":$PATH:" in
            *":$dir:"*) ;;
            *) export PATH="$dir:$PATH" ;;
        esac
    fi
done

# Default System Editor
export EDITOR="hx"
export VISUAL="hx"

# bat configuration
export BAT_CONFIG_PATH="/etc/bat/config"

# Rust Toolchain
export RUSTUP_HOME="/opt/rust/rustup"

# Go Toolchain
export GOBIN="/opt/go/bin"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"

# Helix Editor Runtime
export HELIX_RUNTIME="/opt/helix/runtime"
export ZELLIJ_CONFIG_DIR="/etc/zellij"

# GnuPG Hardware Wallet
if [ -d "$HOME/.gnupg/trezor" ]; then
    export GNUPGHOME="$HOME/.gnupg/trezor"
fi
