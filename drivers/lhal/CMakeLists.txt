sdk_generate_library()

sdk_library_add_sources(src/bflb_common.c)

sdk_library_add_sources(src/bflb_adc.c)

sdk_library_add_sources(src/bflb_dac.c)

sdk_library_add_sources(src/bflb_dma.c)

sdk_library_add_sources(src/bflb_emac.c)

sdk_library_add_sources(src/bflb_gpio.c)
sdk_library_add_sources(src/bflb_i2c.c)

sdk_library_add_sources(src/bflb_ir.c)

sdk_library_add_sources(src/bflb_uart.c)
sdk_library_add_sources(src/bflb_spi.c)
sdk_library_add_sources(src/bflb_rtc.c)
sdk_library_add_sources(src/bflb_sec_aes.c)
sdk_library_add_sources(src/bflb_sec_sha.c)
sdk_library_add_sources(src/bflb_sec_trng.c)

sdk_library_add_sources(src/bflb_timer.c)
sdk_library_add_sources(src/bflb_wdg.c)
sdk_library_add_sources(src/bflb_cks.c)
sdk_library_add_sources(src/bflb_mjpeg.c)
if("${CHIP}" STREQUAL "bl628")
sdk_library_add_sources(src/bflb_clock.c)
endif()
sdk_library_add_sources(src/bflb_ef_ctrl.c)


sdk_library_add_sources(src/bflb_pwm_v2.c)


# optional
sdk_library_add_sources(src/bflb_irq.c)
sdk_library_add_sources(src/bflb_l1c.c)
sdk_library_add_sources(src/bflb_mtimer.c)

sdk_add_include_directories(include)
sdk_add_include_directories(include/arch)
sdk_add_include_directories(include/arch/risc-v/t-head)
sdk_add_include_directories(include/arch/risc-v/t-head/Core/Include)
sdk_add_include_directories(config/${CHIP})

sdk_library_add_sources(include/arch/risc-v/t-head/rv_hart.c)
sdk_library_add_sources(include/arch/risc-v/t-head/rv_pmp.c)


sdk_library_add_sources(config/${CHIP}/device_table.c)

string(TOUPPER ${CHIP} CHIPNAME)
target_compile_definitions(sdk_intf_lib INTERFACE -D${CHIPNAME})

if(CPU_ID)
string(TOUPPER ${CPU_ID} CPU_ID_NAME)
target_compile_definitions(sdk_intf_lib INTERFACE -DCPU_${CPU_ID_NAME})
endif()