get_filename_component(library_name ${CMAKE_CURRENT_LIST_DIR} NAME)

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
config/${CHIP}/device_table.c
)
set_property(GLOBAL APPEND PROPERTY SDK_LIBS ${library_name})
target_link_libraries(lhal PUBLIC sdk_intf_lib)

target_include_directories(sdk_intf_lib INTERFACE include)
target_include_directories(sdk_intf_lib INTERFACE include/arch)
target_include_directories(sdk_intf_lib INTERFACE include/arch/risc-v/t-head)
target_include_directories(sdk_intf_lib INTERFACE include/arch/risc-v/t-head/Core/Include)
target_include_directories(sdk_intf_lib INTERFACE config/${CHIP})


string(TOUPPER ${CHIP} CHIPNAME)
target_compile_definitions(sdk_intf_lib INTERFACE -D${CHIPNAME})

if(CPU_ID)
string(TOUPPER ${CPU_ID} CPU_ID_NAME)
target_compile_definitions(sdk_intf_lib INTERFACE -DCPU_${CPU_ID_NAME})
endif()