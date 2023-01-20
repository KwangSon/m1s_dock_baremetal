cmake_minimum_required(VERSION 3.15)

if(NOT DEFINED ENV{BL_SDK_BASE})
    message( "please set BL_SDK_BASE in your system environment")
endif()

set(BL_SDK_BASE $ENV{BL_SDK_BASE})

set(build_dir build_out)

add_library(sdk_intf_lib INTERFACE)

function(sdk_library_add_sources)
  foreach(arg ${ARGV})
    if(IS_DIRECTORY ${arg})
    message(FATAL_ERROR "sdk_library_add_sources() was called on a directory")
    endif()

    if(IS_ABSOLUTE ${arg})
    set(path ${arg})
    else()
    set(path ${CMAKE_CURRENT_SOURCE_DIR}/${arg})
    endif()
    target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE ${path})
  endforeach()
endfunction()

function(sdk_add_include_directories)
  foreach(arg ${ARGV})
    if(IS_ABSOLUTE ${arg})
      set(path ${arg})
    else()
      set(path ${CMAKE_CURRENT_SOURCE_DIR}/${arg})
    endif()
    target_include_directories(sdk_intf_lib INTERFACE ${path})
  endforeach()
endfunction()

target_link_options(sdk_intf_lib INTERFACE -Wl,--gc-sections)

target_link_libraries(sdk_intf_lib INTERFACE c m)

target_compile_options(sdk_intf_lib INTERFACE -O2)

enable_language(C ASM)

set_property(GLOBAL PROPERTY LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/../${BOARD}/bl808_flash_${CPU_ID}.ld)

add_subdirectory(${BL_SDK_BASE} ${build_dir})

set(proj_name hello_${CHIP}_${CPU_ID})

project(${proj_name} ASM C)

set(BIN_FILE ${build_dir}/${proj_name}.bin)
set(MAP_FILE ${build_dir}/${proj_name}.map)
set(ASM_FILE ${build_dir}/${proj_name}.asm)

add_executable(${proj_name}.elf main.c ${BL_SDK_BASE}/${BOARD}/board.c)
target_include_directories(${proj_name}.elf PUBLIC ${BL_SDK_BASE}/${BOARD})
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