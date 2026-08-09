# Dynamic environment setup for tools installed in /opt
if [ -d "/opt" ]; then

    # 1. PATH (bin & sbin)
    for dir in $(find /opt -mindepth 1 -maxdepth 2 -type d \( -name bin -o -name sbin \) ! -path '/opt/src/*' 2>/dev/null); do
        if [ -z "$PATH" ]; then
            export PATH=$dir
        elif [[ ":$PATH:" != *":$dir:"* ]]; then
            export PATH=$PATH:$dir
        fi
    done

    # 2. LIBRARY_PATH & LD_LIBRARY_PATH (lib & lib64)
    for dir in $(find /opt -mindepth 1 -maxdepth 2 -type d \( -name lib -o -name lib64 \) ! -path '/opt/src/*' 2>/dev/null); do
        if [ -z "$LIBRARY_PATH" ]; then
            export LIBRARY_PATH=$dir
        elif [[ ":$LIBRARY_PATH:" != *":$dir:"* ]]; then
            export LIBRARY_PATH=$dir:$LIBRARY_PATH
        fi
        if [ -z "$LD_LIBRARY_PATH" ]; then
            export LD_LIBRARY_PATH=$dir
        elif [[ ":$LD_LIBRARY_PATH:" != *":$dir:"* ]]; then
            export LD_LIBRARY_PATH=$dir:$LD_LIBRARY_PATH
        fi
    done

    # 3. CPATH (include)
    for dir in $(find /opt -mindepth 1 -maxdepth 2 -type d -name include ! -path '/opt/src/*' 2>/dev/null); do
        if [ -z "$CPATH" ]; then
            export CPATH=$dir
        elif [[ ":$CPATH:" != *":$dir:"* ]]; then
            export CPATH=$dir:$CPATH
        fi
    done

    # 4. PKG_CONFIG_PATH (pkgconfig)
    for dir in $(find /opt -mindepth 1 -maxdepth 3 -type d -name pkgconfig ! -path '/opt/src/*' 2>/dev/null); do
        if [ -z "$PKG_CONFIG_PATH" ]; then
            export PKG_CONFIG_PATH=$dir
        elif [[ ":$PKG_CONFIG_PATH:" != *":$dir:"* ]]; then
            export PKG_CONFIG_PATH=$dir:$PKG_CONFIG_PATH
        fi
    done

fi

# Go Toolchain Executables Path
if [ -d "/opt/src/go/bin" ]; then
    [[ ":$PATH:" != *":/opt/src/go/bin:"* ]] && export PATH="/opt/src/go/bin:$PATH"
elif [ -d "/opt/go/bin" ]; then
    [[ ":$PATH:" != *":/opt/go/bin:"* ]] && export PATH="/opt/go/bin:$PATH"
fi

# Allow user 'go install' binaries ($HOME/go/bin) to work naturally
if [ -d "$HOME/go/bin" ]; then
    [[ ":$PATH:" != *":$HOME/go/bin:"* ]] && export PATH="$HOME/go/bin:$PATH"
fi
