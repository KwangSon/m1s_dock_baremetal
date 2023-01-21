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

set_property(GLOBAL APPEND PROPERTY SDK_LIBS bl808)
target_link_libraries(bl808 PUBLIC sdk_intf_lib)


target_include_directories(sdk_intf_lib INTERFACE 
bl808_std/include
bl808_std/include/hardware
)