sdk_add_include_directories(${BOARD})

sdk_set_linker_script(${BOARD}/bl808_flash_${CPU_ID}.ld)
add_subdirectory(drivers)
add_subdirectory(utils)