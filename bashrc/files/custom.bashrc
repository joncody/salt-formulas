for dir in $(sudo find /opt -mindepth 1 -maxdepth 2 -type d -path /opt/src -prune -o -name bin -printf '%p\n') ; do
    if [ -z "$PATH" ] ; then
        export PATH=$dir
    elif [[ ":$PATH:" != *":$dir:"* ]] ; then
        export PATH=$PATH:$dir
    fi
done

for dir in $(sudo find /opt -mindepth 1 -maxdepth 2 -type d -path /opt/src -prune -o -name sbin -printf '%p\n') ; do
    if [ -z "$PATH" ] ; then
        export PATH=$dir
    elif [[ ":$PATH:" != *":$dir:"* ]] ; then
        export PATH=$PATH:$dir
    fi
done

for dir in $(sudo find /opt -mindepth 1 -maxdepth 2 -type d -path /opt/src -prune -o -name lib -printf '%p\n') ; do
    if [ -z "$LIBRARY_PATH" ] ; then
        export LIBRARY_PATH=$dir
    elif [[ ":$LIBRARY_PATH:" != *":$dir:"* ]] ; then
        export LIBRARY_PATH=$dir:$LIBRARY_PATH
    fi
    if [ -z "$LD_LIBRARY_PATH" ] ; then
        export LD_LIBRARY_PATH=$dir
    elif [[ ":$LD_LIBRARY_PATH:" != *":$dir:"* ]] ; then
        export LD_LIBRARY_PATH=$dir:$LD_LIBRARY_PATH
    fi
done

for dir in $(sudo find /opt -mindepth 1 -maxdepth 2 -type d -path /opt/src -prune -o -name include -printf '%p\n') ; do
    if [ -z "$CPATH" ] ; then
        export CPATH=$dir
    elif [[ ":$CPATH:" != *":$dir:"* ]] ; then
        export CPATH=$dir:$CPATH
    fi
done

for dir in $(sudo find /opt -mindepth 1 -maxdepth 3 -type d -path /opt/src -prune -o -name pkgconfig -printf '%p\n') ; do
    if [ -z "$PKG_CONFIG_PATH" ] ; then
        export PKG_CONFIG_PATH=$dir
    elif [[ ":$PKG_CONFIG_PATH:" != *":$dir:"* ]] ; then
        export PKG_CONFIG_PATH=$dir:$PKG_CONFIG_PATH
    fi
done

export GOROOT_BOOTSTRAP=/opt/src/go_bootstrap
export GOPATH=/opt/go
export GOBIN=/opt/go/bin
export PATH=/opt/src/go/bin:$GOBIN:$PATH
