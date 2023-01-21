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

add_subdirectory(drivers/lhal)
add_subdirectory(drivers ${build_dir})

set(proj_name hello_${CHIP}_${CPU_ID})

project(${proj_name} ASM C)

set(BIN_FILE ${build_dir}/${proj_name}.bin)
set(MAP_FILE ${build_dir}/${proj_name}.map)
set(ASM_FILE ${build_dir}/${proj_name}.asm)

add_executable(${proj_name}.elf main.c board.c)
target_link_libraries(${proj_name}.elf sdk_intf_lib)
get_property(LINKER_SCRIPT_PROPERTY GLOBAL PROPERTY LINKER_SCRIPT)
if(EXISTS ${LINKER_SCRIPT_PROPERTY})
  set_target_properties(${proj_name}.elf PROPERTIES LINK_FLAGS "-T${LINKER_SCRIPT_PROPERTY} -Wl,-Map=${MAP_FILE}")
  set_target_properties(${proj_name}.elf PROPERTIES LINK_DEPENDS ${LINKER_SCRIPT_PROPERTY})
endif()

get_property(SDK_LIBS_PROPERTY GLOBAL PROPERTY SDK_LIBS)
target_link_libraries(${proj_name}.elf -Wl,--start-group ${SDK_LIBS_PROPERTY} -Wl,--end-group)

add_custom_command(TARGET ${proj_name}.elf POST_BUILD
COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${proj_name}.elf> ${BIN_FILE}
COMMAND ${CMAKE_OBJDUMP} -d -S $<TARGET_FILE:${proj_name}.elf> >${ASM_FILE}
COMMENT "Generate ${BIN_FILE}\r\n"
)