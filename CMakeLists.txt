cmake_minimum_required(VERSION 3.15)

add_library(sdk_intf_lib INTERFACE)

include(sdk_intf_lib.cmake)
target_link_libraries(sdk_intf_lib INTERFACE c m)

enable_language(C ASM)

add_library(utils STATIC
utils/libc/vsnprintf.c
utils/libc/syscalls.c
utils/libc/printf.c
utils/mmheap/mmheap.c
utils/soft_crc/soft_crc.c
)
set_property(GLOBAL APPEND PROPERTY SDK_LIBS utils)
target_link_libraries(utils PUBLIC sdk_intf_lib)


add_subdirectory(drivers/lhal)
add_subdirectory(drivers/soc/${CHIP})

set(proj_name hello_${CHIP}_${CPU_ID})

project(${proj_name} ASM C)

set(BIN_FILE ${proj_name}.bin)
set(MAP_FILE ${proj_name}.map)
set(ASM_FILE ${proj_name}.asm)

add_executable(${proj_name}.elf main.c board.c)
target_link_libraries(${proj_name}.elf sdk_intf_lib)

set_property(GLOBAL PROPERTY LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/bl808_flash_${CPU_ID}.ld)

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