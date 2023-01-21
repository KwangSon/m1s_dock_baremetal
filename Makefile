CHIP ?= bl808

CPU_ID ?= m0

cmake_definition+= -DCHIP=$(CHIP)
cmake_definition+= -DCPU_ID=$(CPU_ID)
cmake_definition+= -DCMAKE_BUILD_TYPE=Debug
cmake_definition+= -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

build:Makefile
	CC=riscv64-unknown-elf-gcc \
	cmake -S . -B build -G "Unix Makefiles" $(cmake_definition)
	cd build && make -j4

clean:
	rm -rf build