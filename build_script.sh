#!/bin/sh

cd ../..
SPICE_ROOT=`pwd`
SRC_ROOT=$SPICE_ROOT/src
INST_ROOT=$SPICE_ROOT/rel

echo "P= $0 $1 $2 $3 $4"
#[ -e $1 ] && echo "Building $1 ..." || exit 1
[ -d ${SRC_ROOT} ]  && echo "SRC_ROOT=${SRC_ROOT}" || exit 1
[ -d ${INST_ROOT} ] && echo "INST_ROOT=${INST_ROOT}" || exit 1

export PKG_CONFIG_PATH=$INST_ROOT/lib/pkgconfig:$INST_ROOT/share/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$INST_ROOT/lib
export PATH=$PATH:$INST_ROOT/bin

[ -d ${SRC_ROOT}/$1 ] && echo "Staring build $1 ..." || exit 1
cd ${SRC_ROOT}/$1
echo "PKG_CONFIG_PATH=${PKG_CONFIG_PATH}"

case $1 in
        spice)
        	SPICE_PROTOCOL_PATH=`pkg-config --cflags spice-protocol`
        	echo "SPICE_PROTOCOL_PATH=${SPICE_PROTOCOL_PATH}"
            ./autogen.sh --prefix=${INST_ROOT}
        ;;
        spice-protocol)
            ./autogen.sh --prefix=${INST_ROOT}
        ;;
        spice-gtk)
            ./autogen.sh --prefix=${INST_ROOT}
        ;;
        virt-viewer)
            ./autogen.sh --prefix=${INST_ROOT} --with-spice-gtk
        ;;
        qemu)
            ../configure --target-list=aarch64-softmmu,x86_64-softmmu --enable-gtk --with-gtkabi=3.0 --enable-kvm --enable-spice --enable-usb-redir --enable-libusb --prefix=${INST_ROOT}
        ;;
        *)
                exit
        ;;
esac

# ./autogen.sh --prefix=${INST_ROOT}
make install