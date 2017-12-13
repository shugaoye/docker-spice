#!/bin/sh

ARCH=aarch64
TOOL_ROOT=/home/optee/bin
IMAGE_ROOT=/home/optee/rel

if [ -n "$1" ]; then
        echo Using image $1
	IMAGE=$1
	WORK_DIR=$IMAGE_ROOT
else
        IMAGE="$IMAGE_ROOT/bl1.bin"
	WORK_DIR=$IMAGE_ROOT
fi

nc -z  127.0.0.1 54320 || /usr/bin/xterm -title "Normal World" -e bash -c "$TOOL_ROOT/soc_term 54320" &
nc -z  127.0.0.1 54321 || /usr/bin/xterm -title "Secure World" -e bash -c "$TOOL_ROOT/soc_term 54321" &
while ! nc -z 127.0.0.1 54320 || ! nc -z 127.0.0.1 54321; do sleep 1; done

(cd ${WORK_DIR} && $TOOL_ROOT/${ARCH}-softmmu/qemu-system-${ARCH} \
		-nographic \
		-netdev user,tftp=/home/aosp/TFTP/,bootfile=tftp://10.0.2.2/grubaa64.efi,id=mynet,hostfwd=tcp::5555-:5555,hostfwd=tcp::10000-:10000 \
		-device virtio-net-pci,netdev=mynet \
		-serial tcp:localhost:54320 -serial tcp:localhost:54321 \
		-s -S -machine virt -machine secure=on -cpu cortex-a57 \
		-d unimp -semihosting-config enable,target=native \
		-kernel zImage -initrd rootfs.cpio.gz -smp 2 -m 1057 \
		-bios $IMAGE \
		)
