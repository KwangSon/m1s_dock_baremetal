sdk_add_include_directories(board/${BOARD})

sdk_set_linker_script(board/${BOARD}/bl808_flash_${CPU_ID}.ld)

if(CONFIG_PSRAM)
sdk_add_compile_definitions(-DCONFIG_PSRAM)
endif()