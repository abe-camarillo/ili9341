obj-m += ili9341.o

# Kernel build directory
KERNELDIR ?= /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

# Default target
all: ili9341.ko

# Build the kernel module
ili9341.ko:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

# Clean build artifacts
clean:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean
	rm -f *.o *.ko *.mod.c *.mod *.symvers *.order *~ .*.cmd *.dtbo

# Install module (requires root)
install: ili9341.ko
	sudo insmod ili9341.ko

# Remove module
uninstall:
	sudo rmmod ili9341 2>/dev/null || true

# Load module and wait a moment
load: uninstall install
	@sleep 2
	@dmesg | tail -20

# Clean all and rebuild
rebuild: clean all

# Build Device Tree overlay
dtbo: ili9341-overlay.dtbo

ili9341-overlay.dtbo: ili9341-overlay.dts
	dtc -@ -I dts -O dtb -o $@ $<

# Build everything
all-with-overlay: ili9341.ko ili9341-overlay.dtbo
