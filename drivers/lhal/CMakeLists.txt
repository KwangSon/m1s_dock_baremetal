get_filename_component(library_name ${CMAKE_CURRENT_LIST_DIR} NAME)

message(STATUS "[register library : ${library_name}], path:${CMAKE_CURRENT_LIST_DIR}")

set(CURRENT_STATIC_LIBRARY ${library_name})
add_library(${library_name} STATIC)
set_property(GLOBAL APPEND PROPERTY SDK_LIBS ${library_name})
target_link_libraries(${library_name} PUBLIC sdk_intf_lib)

target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_common.c)

target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_adc.c)

target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_dac.c)

target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_dma.c)

target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_emac.c)

target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_gpio.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_i2c.c)

target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_ir.c)

target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_uart.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_spi.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_rtc.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_sec_aes.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_sec_sha.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_sec_trng.c)

target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_timer.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_wdg.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_cks.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_mjpeg.c)
if("${CHIP}" STREQUAL "bl628")
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_clock.c)
endif()
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_ef_ctrl.c)


target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_pwm_v2.c)


# optional
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_irq.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_l1c.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE src/bflb_mtimer.c)

target_include_directories(sdk_intf_lib INTERFACE include)
target_include_directories(sdk_intf_lib INTERFACE include/arch)
target_include_directories(sdk_intf_lib INTERFACE include/arch/risc-v/t-head)
target_include_directories(sdk_intf_lib INTERFACE include/arch/risc-v/t-head/Core/Include)
target_include_directories(sdk_intf_lib INTERFACE config/${CHIP})

target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE include/arch/risc-v/t-head/rv_hart.c)
target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE include/arch/risc-v/t-head/rv_pmp.c)


target_sources(${CURRENT_STATIC_LIBRARY} PRIVATE config/${CHIP}/device_table.c)

string(TOUPPER ${CHIP} CHIPNAME)
target_compile_definitions(sdk_intf_lib INTERFACE -D${CHIPNAME})

if(CPU_ID)
string(TOUPPER ${CPU_ID} CPU_ID_NAME)
target_compile_definitions(sdk_intf_lib INTERFACE -DCPU_${CPU_ID_NAME})
endif()