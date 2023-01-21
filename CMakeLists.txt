cmake_minimum_required(VERSION 3.15)

set(build_dir build_out)

add_library(sdk_intf_lib INTERFACE)

target_link_options(sdk_intf_lib INTERFACE -Wl,--gc-sections)

target_link_libraries(sdk_intf_lib INTERFACE c m)

target_compile_options(sdk_intf_lib INTERFACE -O2)

enable_language(C ASM)

set_property(GLOBAL PROPERTY LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/bl808_flash_${CPU_ID}.ld)

add_library(utils STATIC
utils/libc/vsnprintf.c
utils/libc/syscalls.c
utils/libc/printf.c
utils/mmheap/mmheap.c
utils/soft_crc/soft_crc.c
)
set_property(GLOBAL APPEND PROPERTY SDK_LIBS utils)
target_link_libraries(utils PUBLIC sdk_intf_lib)


target_include_directories(sdk_intf_lib INTERFACE utils/mmheap)
target_include_directories(sdk_intf_lib INTERFACE utils/soft_crc)

target_include_directories(sdk_intf_lib INTERFACE drivers/lhal/include)
target_include_directories(sdk_intf_lib INTERFACE drivers/lhal/include/arch)
target_include_directories(sdk_intf_lib INTERFACE drivers/lhal/include/arch/risc-v/t-head)
target_include_directories(sdk_intf_lib INTERFACE drivers/lhal/include/arch/risc-v/t-head/Core/Include)
target_include_directories(sdk_intf_lib INTERFACE drivers/lhal/config/${CHIP})


string(TOUPPER ${CHIP} CHIPNAME)
target_compile_definitions(sdk_intf_lib INTERFACE -D${CHIPNAME})

if(CPU_ID)
string(TOUPPER ${CPU_ID} CPU_ID_NAME)
target_compile_definitions(sdk_intf_lib INTERFACE -DCPU_${CPU_ID_NAME})
endif()

if("${CPU_ID}" STREQUAL "m0")
SET(MCPU "e907")
SET(MARCH "rv32imafcpzpsfoperand_xtheade")
SET(MABI "ilp32f")
elseif("${CPU_ID}" STREQUAL "d0")
SET(MCPU "c906")
SET(MARCH "rv64imafdcv0p7_zfh_xtheadc")
SET(MABI "lp64d")
elseif("${CPU_ID}" STREQUAL "lp")
SET(MCPU "e902")
SET(MARCH "rv32emcxtheadse")
SET(MABI "ilp32e")
endif()

target_compile_definitions(sdk_intf_lib INTERFACE -DARCH_RISCV -DBFLB_USE_HAL_DRIVER)
target_compile_options(sdk_intf_lib INTERFACE -march=${MARCH} -mabi=${MABI} -mtune=${MCPU})
target_link_options(sdk_intf_lib INTERFACE -march=${MARCH} -mabi=${MABI} -mtune=${MCPU})

target_compile_definitions(sdk_intf_lib INTERFACE -DCONFIG_IRQ_NUM=80)
add_subdirectory(drivers/lhal)
add_subdirectory(drivers)

set(proj_name hello_${CHIP}_${CPU_ID})

project(${proj_name} ASM C)

set(BIN_FILE ${proj_name}.bin)
set(MAP_FILE ${proj_name}.map)
set(ASM_FILE ${proj_name}.asm)

add_executable(${proj_name}.elf main.c board.c)
target_link_libraries(${proj_name}.elf sdk_intf_lib)
get_property(LINKER_SCRIPT_PROPERTY GLOBAL PROPERTY LINKER_SCRIPT)

set_target_properties(${proj_name}.elf PROPERTIES LINK_FLAGS "-T${LINKER_SCRIPT_PROPERTY} -Wl,-Map=${MAP_FILE}")
set_target_properties(${proj_name}.elf PROPERTIES LINK_DEPENDS ${LINKER_SCRIPT_PROPERTY})


get_property(SDK_LIBS_PROPERTY GLOBAL PROPERTY SDK_LIBS)
target_link_libraries(${proj_name}.elf -Wl,--start-group ${SDK_LIBS_PROPERTY} -Wl,--end-group)

add_custom_command(TARGET ${proj_name}.elf POST_BUILD
COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${proj_name}.elf> ${BIN_FILE}
COMMAND ${CMAKE_OBJDUMP} -d -S $<TARGET_FILE:${proj_name}.elf> >${ASM_FILE}
COMMENT "Generate ${BIN_FILE}\r\n"
)