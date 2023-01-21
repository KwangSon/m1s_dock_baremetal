get_filename_component(library_name ${CMAKE_CURRENT_LIST_DIR} NAME)

set(CURRENT_STATIC_LIBRARY bl808)
add_library(bl808 STATIC


startup/${CPU_ID}/start.S
startup/${CPU_ID}/vector.S
startup/${CPU_ID}/riscv_fpu.S
startup/${CPU_ID}/start_load.c
startup/${CPU_ID}/system_bl808.c
startup/${CPU_ID}/interrupt.c

bl808_std/src/bl808_aon.c
bl808_std/src/bl808_clock.c
bl808_std/src/bl808_common.c
bl808_std/src/bl808_ef_cfg.c
bl808_std/src/bl808_glb.c
bl808_std/src/bl808_hbn.c
bl808_std/src/bl808_l1c.c
bl808_std/src/bl808_pds.c
bl808_std/src/bl808_sdh.c

bl808_std/src/bl808_tzc_sec.c
bl808_std/src/bl808_psram_uhs.c
bl808_std/src/bl808_uhs_phy.c

bl808_std/src/bl808_sf_cfg.c
bl808_std/src/bl808_sf_ctrl.c
bl808_std/src/bl808_sflash.c
bl808_std/src/bl808_xip_sflash.c

port/bl808_clock.c
port/bl808_flash.c
port/bl808_efuse.c)
target_link_libraries(bl808 PUBLIC sdk_intf_lib)
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