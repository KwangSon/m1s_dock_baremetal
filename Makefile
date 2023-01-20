CHIP ?= bl808
BOARD ?= bl808dk

CPU_ID ?= m0
CONFIG_USB_HS ?=y
CONFIG_ROMAPI ?=y

cmake_definition+= -DCHIP=$(CHIP)
cmake_definition+= -DCPU_ID=$(CPU_ID)
cmake_definition+= -DBOARD=$(BOARD)
cmake_definition+= -DCMAKE_BUILD_TYPE=Debug
cmake_definition+= -DCONFIG_ROMAPI=$(CONFIG_ROMAPI)
cmake_definition+= -DCONFIG_USB_HS=$(CONFIG_USB_HS)
cmake_definition+= -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

build:Makefile
	CC=riscv64-unknown-elf-gcc cmake -S . -B build -G "Unix Makefiles" $(cmake_definition)
	cd build && make -j4

clean:
	rm -rf build