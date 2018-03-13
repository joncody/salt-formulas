for dir in $(sudo find /opt -mindepth 1 -maxdepth 2 -type d -path /opt/src -prune -o -name bin -printf '%p\n')
do
    export PATH=$dir:$PATH
done

for dir in $(sudo find /opt -mindepth 1 -maxdepth 2 -type d -path /opt/src -prune -o -name sbin -printf '%p\n')
do
    export PATH=$dir:$PATH
done

for dir in $(sudo find /opt -mindepth 1 -maxdepth 2 -type d -path /opt/src -prune -o -name lib -printf '%p\n')
do
    export LIBRARY_PATH=$dir:$LIBRARY_PATH
    export LD_LIBRARY_PATH=$dir:$LD_LIBRARY_PATH
done

for dir in $(sudo find /opt -mindepth 1 -maxdepth 2 -type d -path /opt/src -prune -o -name include -printf '%p\n')
do
    export CPATH=$dir:$CPATH
done

for dir in $(sudo find /opt -mindepth 1 -maxdepth 3 -type d -path /opt/src -prune -o -name pkgconfig -printf '%p\n')
do
    export PKG_CONFIG_PATH=$dir:$PKG_CONFIG_PATH
done
