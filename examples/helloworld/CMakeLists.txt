cmake_minimum_required(VERSION 3.15)

set(CONFIG_VLIBC 0)
set(CONFIG_BFLOG 0)

include($ENV{BL_SDK_BASE}/cmake/bouffalo_sdk-config.cmake)

sdk_set_main_file(main.c)

project(helloworld)
