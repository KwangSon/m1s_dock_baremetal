cmake_minimum_required(VERSION 3.15)

set(proj_name hello_${CHIP}_${CPU_ID})
project(${proj_name} C ASM)

set(util_src
utils/libc/vsnprintf.c
utils/libc/syscalls.c
utils/libc/printf.c
utils/mmheap/mmheap.c
utils/soft_crc/soft_crc.c
)

set(lhal_src
drivers/lhal/src/bflb_common.c
drivers/lhal/src/bflb_adc.c
drivers/lhal/src/bflb_dac.c
drivers/lhal/src/bflb_dma.c
drivers/lhal/src/bflb_emac.c
drivers/lhal/src/bflb_gpio.c
drivers/lhal/src/bflb_i2c.c
drivers/lhal/src/bflb_ir.c
drivers/lhal/src/bflb_uart.c
drivers/lhal/src/bflb_spi.c
drivers/lhal/src/bflb_rtc.c
drivers/lhal/src/bflb_sec_aes.c
drivers/lhal/src/bflb_sec_sha.c
drivers/lhal/src/bflb_sec_trng.c
drivers/lhal/src/bflb_timer.c
drivers/lhal/src/bflb_wdg.c
drivers/lhal/src/bflb_cks.c
drivers/lhal/src/bflb_mjpeg.c
drivers/lhal/src/bflb_ef_ctrl.c
drivers/lhal/src/bflb_pwm_v2.c
drivers/lhal/src/bflb_irq.c
drivers/lhal/src/bflb_l1c.c
drivers/lhal/src/bflb_mtimer.c
drivers/lhal/include/arch/risc-v/t-head/rv_hart.c
drivers/lhal/include/arch/risc-v/t-head/rv_pmp.c
drivers/lhal/config/${CHIP}/device_table.c
)

set(bl808_src
drivers/soc/bl808/startup/${CPU_ID}/start.S
drivers/soc/bl808/startup/${CPU_ID}/vector.S
drivers/soc/bl808/startup/${CPU_ID}/riscv_fpu.S
drivers/soc/bl808/startup/${CPU_ID}/start_load.c
drivers/soc/bl808/startup/${CPU_ID}/system_bl808.c
drivers/soc/bl808/startup/${CPU_ID}/interrupt.c
drivers/soc/bl808/bl808_std/src/bl808_aon.c
drivers/soc/bl808/bl808_std/src/bl808_clock.c
drivers/soc/bl808/bl808_std/src/bl808_common.c
drivers/soc/bl808/bl808_std/src/bl808_ef_cfg.c
drivers/soc/bl808/bl808_std/src/bl808_glb.c
drivers/soc/bl808/bl808_std/src/bl808_hbn.c
drivers/soc/bl808/bl808_std/src/bl808_l1c.c
drivers/soc/bl808/bl808_std/src/bl808_pds.c
drivers/soc/bl808/bl808_std/src/bl808_sdh.c
drivers/soc/bl808/bl808_std/src/bl808_tzc_sec.c
drivers/soc/bl808/bl808_std/src/bl808_psram_uhs.c
drivers/soc/bl808/bl808_std/src/bl808_uhs_phy.c
drivers/soc/bl808/bl808_std/src/bl808_sf_cfg.c
drivers/soc/bl808/bl808_std/src/bl808_sf_ctrl.c
drivers/soc/bl808/bl808_std/src/bl808_sflash.c
drivers/soc/bl808/bl808_std/src/bl808_xip_sflash.c
drivers/soc/bl808/port/bl808_clock.c
drivers/soc/bl808/port/bl808_flash.c
drivers/soc/bl808/port/bl808_efuse.c
)

add_executable(${proj_name}.elf board.c
${bl808_src}
${lhal_src}
${util_src}
)

if("${CPU_ID}" STREQUAL "m0")
SET(MARCH "rv32imafc")
SET(MABI "ilp32f")
endif()

target_link_options(${proj_name}.elf PUBLIC
-Wl,--gc-sections -march=${MARCH} -mabi=${MABI}
)

target_compile_options(${proj_name}.elf PUBLIC -O2 -march=${MARCH} -mabi=${MABI})

string(TOUPPER ${CHIP} CHIPNAME)
target_compile_definitions(${proj_name}.elf PUBLIC -D${CHIPNAME})
if(CPU_ID)
string(TOUPPER ${CPU_ID} CPU_ID_NAME)
target_compile_definitions(${proj_name}.elf PUBLIC -DCPU_${CPU_ID_NAME})
endif()
target_compile_definitions(${proj_name}.elf PUBLIC -DARCH_RISCV -DBFLB_USE_HAL_DRIVER)
target_compile_definitions(${proj_name}.elf PUBLIC -DCONFIG_IRQ_NUM=80)

target_include_directories(${proj_name}.elf PUBLIC utils/mmheap)
target_include_directories(${proj_name}.elf PUBLIC utils/soft_crc)
target_include_directories(${proj_name}.elf PUBLIC drivers/lhal/include)
target_include_directories(${proj_name}.elf PUBLIC drivers/lhal/include/arch)
target_include_directories(${proj_name}.elf PUBLIC drivers/lhal/include/arch/risc-v/t-head)
target_include_directories(${proj_name}.elf PUBLIC drivers/lhal/include/arch/risc-v/t-head/Core/Include)
target_include_directories(${proj_name}.elf PUBLIC drivers/lhal/config/${CHIP})

target_include_directories(${proj_name}.elf PUBLIC 
drivers/soc/bl808/bl808_std/include
drivers/soc/bl808/bl808_std/include/hardware
)

set_property(GLOBAL PROPERTY LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/bl808_flash_${CPU_ID}.ld)
get_property(LINKER_SCRIPT_PROPERTY GLOBAL PROPERTY LINKER_SCRIPT)

set_target_properties(${proj_name}.elf PROPERTIES LINK_FLAGS "-T${LINKER_SCRIPT_PROPERTY}")
set_target_properties(${proj_name}.elf PROPERTIES LINK_DEPENDS ${LINKER_SCRIPT_PROPERTY})

set(BIN_FILE ${proj_name}.bin)
add_custom_command(TARGET ${proj_name}.elf POST_BUILD
COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${proj_name}.elf> ${BIN_FILE}
COMMENT "Generate ${BIN_FILE}\r\n"
)