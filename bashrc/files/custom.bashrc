for dir in $(sudo find /opt -mindepth 1 -maxdepth 2 -type d -path /opt/src -prune -o -name bin -printf '%p\n') ; do
    if [ -z "$PATH" ] ; then
        export PATH=$dir
    else
        if [[ ":$PATH:" != *":$dir:"* ]] ; then
            export PATH=$PATH:$dir
        fi
    fi
done

for dir in $(sudo find /opt -mindepth 1 -maxdepth 2 -type d -path /opt/src -prune -o -name sbin -printf '%p\n') ; do
    if [ -z "$PATH" ] ; then
        export PATH=$dir
    else
        if [[ ":$PATH:" != *":$dir:"* ]] ; then
            export PATH=$PATH:$dir
        fi
    fi
done

for dir in $(sudo find /opt -mindepth 1 -maxdepth 2 -type d -path /opt/src -prune -o -name lib -printf '%p\n') ; do
    if [ -z "$LIBRARY_PATH" ] ; then
        export LIBRARY_PATH=$dir
    else
        if [[ ":$LIBRARY_PATH:" != *":$dir:"* ]] ; then
            export LIBRARY_PATH=$dir:$LIBRARY_PATH
        fi
    fi
    if [ -z "$LD_LIBRARY_PATH" ] ; then
        export LD_LIBRARY_PATH=$dir
    else
        if [[ ":$LD_LIBRARY_PATH:" != *":$dir:"* ]] ; then
            export LD_LIBRARY_PATH=$dir:$LD_LIBRARY_PATH
        fi
    fi
done

for dir in $(sudo find /opt -mindepth 1 -maxdepth 2 -type d -path /opt/src -prune -o -name include -printf '%p\n') ; do
    if [ -z "$CPATH" ] ; then
        export CPATH=$dir
    else
        if [[ ":$CPATH:" != *":$dir:"* ]] ; then
            export CPATH=$dir:$CPATH
        fi
    fi
done

for dir in $(sudo find /opt -mindepth 1 -maxdepth 3 -type d -path /opt/src -prune -o -name pkgconfig -printf '%p\n') ; do
    if [ -z "$PKG_CONFIG_PATH" ] ; then
        export PKG_CONFIG_PATH=$dir
    else
        if [[ ":$PKG_CONFIG_PATH:" != *":$dir:"* ]] ; then
            export PKG_CONFIG_PATH=$dir:$PKG_CONFIG_PATH
        fi
    fi
done
