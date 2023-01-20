cmake_minimum_required(VERSION 3.15)

set(CONFIG_VLIBC 0)
set(CONFIG_BFLOG 0)

find_package(bouffalo_sdk REQUIRED HINTS $ENV{BL_SDK_BASE})

sdk_set_main_file(main.c)

project(helloworld)
