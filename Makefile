BL_SDK_BASE ?= ../..

export BL_SDK_BASE

CHIP ?= bl808
BOARD ?= bl808dk
CROSS_COMPILE ?= riscv64-unknown-elf-

export CROSS_COMPILE

CPU_ID ?= m0
CONFIG_USB_HS ?=y
CONFIG_ROMAPI ?=y
CONFIG_DEBUG ?=y

cmake_definition+= -DCHIP=$(CHIP)
cmake_definition+= -DCPU_ID=$(CPU_ID)
cmake_definition+= -DBOARD=$(BOARD)
cmake_definition+= -DCONFIG_DEBUG=$(CONFIG_DEBUG)
cmake_definition+= -DCONFIG_ROMAPI=$(CONFIG_ROMAPI)
cmake_definition+= -DCONFIG_USB_HS=$(CONFIG_USB_HS)
cmake_definition+= -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

build:Makefile
	cd examples/helloworld/ && \
	CC=riscv64-unknown-elf-gcc cmake -S . -B build -G "Unix Makefiles" $(cmake_definition)
	cd examples/helloworld/build && make -j4

clean:
	rm -rf examples/helloworld/build