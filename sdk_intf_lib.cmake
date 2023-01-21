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


target_link_options(sdk_intf_lib INTERFACE
-Wl,--gc-sections -march=${MARCH} -mabi=${MABI} -mtune=${MCPU}
)

target_compile_options(sdk_intf_lib INTERFACE -O2 -march=${MARCH} -mabi=${MABI} -mtune=${MCPU})

string(TOUPPER ${CHIP} CHIPNAME)
target_compile_definitions(sdk_intf_lib INTERFACE -D${CHIPNAME})
if(CPU_ID)
string(TOUPPER ${CPU_ID} CPU_ID_NAME)
target_compile_definitions(sdk_intf_lib INTERFACE -DCPU_${CPU_ID_NAME})
endif()
target_compile_definitions(sdk_intf_lib INTERFACE -DARCH_RISCV -DBFLB_USE_HAL_DRIVER)
target_compile_definitions(sdk_intf_lib INTERFACE -DCONFIG_IRQ_NUM=80)

target_include_directories(sdk_intf_lib INTERFACE utils/mmheap)
target_include_directories(sdk_intf_lib INTERFACE utils/soft_crc)
target_include_directories(sdk_intf_lib INTERFACE drivers/lhal/include)
target_include_directories(sdk_intf_lib INTERFACE drivers/lhal/include/arch)
target_include_directories(sdk_intf_lib INTERFACE drivers/lhal/include/arch/risc-v/t-head)
target_include_directories(sdk_intf_lib INTERFACE drivers/lhal/include/arch/risc-v/t-head/Core/Include)
target_include_directories(sdk_intf_lib INTERFACE drivers/lhal/config/${CHIP})

target_include_directories(sdk_intf_lib INTERFACE 
drivers/soc/bl808/bl808_std/include
drivers/soc/bl808/bl808_std/include/hardware
)