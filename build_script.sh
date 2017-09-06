#!/bin/sh

cd ../..
SPICE_ROOT=`pwd`
# [ -z $1 ] && SPICE_ROOT=`pwd` || SPICE_ROOT=$1

SRC_ROOT=$SPICE_ROOT/src
INST_ROOT=$SPICE_ROOT/rel

echo "P= $0 $1 $2 $3 $4"
[ -d ${SRC_ROOT} ]  && echo "SRC_ROOT=${SRC_ROOT}" || exit 1
[ -d ${INST_ROOT} ] && echo "INST_ROOT=${INST_ROOT}" || exit 1

export PKG_CONFIG_PATH=$INST_ROOT/lib/pkgconfig:$INST_ROOT/share/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$INST_ROOT/lib
export PATH=$PATH:$INST_ROOT/bin

echo "PKG_CONFIG_PATH=${PKG_CONFIG_PATH}, PATH=${PATH}"
SPICE_PROTOCOL_PATH=`pkg-config --cflags spice-protocol`
echo "SPICE_PROTOCOL_PATH=${SPICE_PROTOCOL_PATH}"

case $1 in
	    links)
	        cp src/docker-spice/utils/test_qemu.sh $INST_ROOT/bin/test_qemu.sh
	        cd $INST_ROOT/bin
	        ln -s ./test_qemu.sh x86qemu_pxe
	        ln -s ./test_qemu.sh x86qemu_iso
        ;;
        virglrenderer)
        	[ -d ${SRC_ROOT}/$1 ] && cd ${SRC_ROOT}/$1 || exit 1
            ./autogen.sh --prefix=${INST_ROOT}
            make install
        ;;
        spice)
        	[ -d ${SRC_ROOT}/$1 ] && cd ${SRC_ROOT}/$1 || exit 1
            ./autogen.sh --prefix=${INST_ROOT}
            make install
        ;;
        spice-protocol)
            [ -d ${SRC_ROOT}/$1 ] && cd ${SRC_ROOT}/$1 || exit 1
            ./autogen.sh --prefix=${INST_ROOT}
            make install
        ;;
        spice-gtk)
            [ -d ${SRC_ROOT}/$1 ] && cd ${SRC_ROOT}/$1 || exit 1
            ./autogen.sh --prefix=${INST_ROOT}
            make install
        ;;
        virt-viewer)
            [ -d ${SRC_ROOT}/$1 ] && cd ${SRC_ROOT}/$1 || exit 1
            ./autogen.sh --prefix=${INST_ROOT} --with-spice-gtk
            make install
        ;;
        qemu)
            [ -d ${SRC_ROOT}/$1 ] && cd ${SRC_ROOT}/$1 || exit 1
            [ -d build ] && echo "Buiding QEMU in build folder." || mkdir build
            cd build
            ../configure --target-list=aarch64-softmmu,x86_64-softmmu --enable-gtk --with-gtkabi=3.0 \
            --enable-kvm --enable-spice --enable-usb-redir --enable-libusb --prefix=${INST_ROOT}
            make install
        ;;
        *)
            echo "Nothing to build."
            exit
        ;;
esac
