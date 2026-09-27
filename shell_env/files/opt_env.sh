# Dynamic environment setup for tools installed in /opt
if [ -d "/opt" ]; then

    # 1. PATH (bin & sbin)
    for dir in $(find /opt -mindepth 1 -maxdepth 2 -type d \( -name bin -o -name sbin \) ! -path '/opt/src/*' 2>/dev/null); do
        case ":$PATH:" in
            *":$dir:"*) ;;
            *) export PATH="${PATH:+$PATH:}$dir" ;;
        esac
    done

    # 2. LIBRARY_PATH & LD_LIBRARY_PATH (lib & lib64)
    for dir in $(find /opt -mindepth 1 -maxdepth 2 -type d \( -name lib -o -name lib64 \) ! -path '/opt/src/*' 2>/dev/null); do
        case ":$LIBRARY_PATH:" in
            *":$dir:"*) ;;
            *) export LIBRARY_PATH="${dir}${LIBRARY_PATH:+:$LIBRARY_PATH}" ;;
        esac
        case ":$LD_LIBRARY_PATH:" in
            *":$dir:"*) ;;
            *) export LD_LIBRARY_PATH="${dir}${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" ;;
        esac
    done

    # 3. CPATH (include)
    for dir in $(find /opt -mindepth 1 -maxdepth 2 -type d -name include ! -path '/opt/src/*' 2>/dev/null); do
        case ":$CPATH:" in
            *":$dir:"*) ;;
            *) export CPATH="${dir}${CPATH:+:$CPATH}" ;;
        esac
    done

    # 4. PKG_CONFIG_PATH (pkgconfig)
    for dir in $(find /opt -mindepth 1 -maxdepth 3 -type d -name pkgconfig ! -path '/opt/src/*' 2>/dev/null); do
        case ":$PKG_CONFIG_PATH:" in
            *":$dir:"*) ;;
            *) export PKG_CONFIG_PATH="${dir}${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}" ;;
        esac
    done

fi

# Go Toolchain Workspace and Destination
export GOPATH="/opt/go"
export GOBIN="/opt/go/bin"
case ":$PATH:" in
    *":/opt/go/bin:"*) ;;
    *) export PATH="/opt/go/bin:$PATH" ;;
esac
