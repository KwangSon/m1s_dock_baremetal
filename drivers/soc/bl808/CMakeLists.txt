get_filename_component(library_name ${CMAKE_CURRENT_LIST_DIR} NAME)

message(STATUS "[register library : ${library_name}], path:${CMAKE_CURRENT_LIST_DIR}")

set(CURRENT_STATIC_LIBRARY ${library_name})
add_library(${library_name} STATIC)
set_property(GLOBAL APPEND PROPERTY SDK_LIBS ${library_name})
target_link_libraries(${library_name} PUBLIC sdk_intf_lib)

target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE startup/${CPU_ID}/start.S)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE startup/${CPU_ID}/vector.S)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE startup/${CPU_ID}/riscv_fpu.S)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE startup/${CPU_ID}/start_load.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE startup/${CPU_ID}/system_bl808.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE startup/${CPU_ID}/interrupt.c)

target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE bl808_std/src/bl808_aon.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE bl808_std/src/bl808_clock.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE bl808_std/src/bl808_common.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE bl808_std/src/bl808_ef_cfg.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE bl808_std/src/bl808_glb.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE bl808_std/src/bl808_hbn.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE bl808_std/src/bl808_l1c.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE bl808_std/src/bl808_pds.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE bl808_std/src/bl808_sdh.c)

target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE bl808_std/src/bl808_tzc_sec.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE bl808_std/src/bl808_psram_uhs.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE bl808_std/src/bl808_uhs_phy.c)

target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE bl808_std/src/bl808_sf_cfg.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE bl808_std/src/bl808_sf_ctrl.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE bl808_std/src/bl808_sflash.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE bl808_std/src/bl808_xip_sflash.c)

target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE port/bl808_clock.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE port/bl808_flash.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE port/bl808_efuse.c)

target_include_directories(sdk_intf_lib INTERFACE 
bl808_std/include
bl808_std/include/hardware
)

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