# Dynamic environment setup for tools installed in /opt
if [ -d "/opt" ]; then

    # 1. PATH (bin & sbin)
    for dir in $(find /opt -mindepth 1 -maxdepth 2 -type d \( -name bin -o -name sbin \) ! -path '/opt/src/*' 2>/dev/null); do
        case ":$PATH:" in
            *":$dir:"*) ;;
            *) export PATH="${PATH:+$PATH:}$dir" ;;
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

# Rust Toolchain: System-wide toolchain location
export RUSTUP_HOME="/opt/rust/rustup"

# Go Toolchain: Binaries to /opt/go/bin, keep GOPATH separate from GOROOT
export GOBIN="/opt/go/bin"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"

case ":$PATH:" in
    *":/opt/go/bin:"*) ;;
    *) export PATH="/opt/go/bin:$PATH" ;;
esac
