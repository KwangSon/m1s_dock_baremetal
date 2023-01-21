add_library(lhal STATIC
src/bflb_common.c
src/bflb_adc.c
src/bflb_dac.c
src/bflb_dma.c
src/bflb_emac.c
src/bflb_gpio.c
src/bflb_i2c.c
src/bflb_ir.c
src/bflb_uart.c
src/bflb_spi.c
src/bflb_rtc.c
src/bflb_sec_aes.c
src/bflb_sec_sha.c
src/bflb_sec_trng.c
src/bflb_timer.c
src/bflb_wdg.c
src/bflb_cks.c
src/bflb_mjpeg.c
src/bflb_ef_ctrl.c
src/bflb_pwm_v2.c
src/bflb_irq.c
src/bflb_l1c.c
src/bflb_mtimer.c
include/arch/risc-v/t-head/rv_hart.c
include/arch/risc-v/t-head/rv_pmp.c
config/${CHIP}/device_table.c)

set_property(GLOBAL APPEND PROPERTY SDK_LIBS lhal)
target_link_libraries(lhal PUBLIC sdk_intf_lib)