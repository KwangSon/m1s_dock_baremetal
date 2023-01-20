set(CURRENT_STATIC_LIBRARY utils)
add_library(utils STATIC
libc/vsnprintf.c
libc/syscalls.c
libc/printf.c
mmheap/mmheap.c
soft_crc/soft_crc.c
)
set_property(GLOBAL APPEND PROPERTY SDK_LIBS utils)
target_link_libraries(utils PUBLIC sdk_intf_lib)


sdk_add_include_directories(mmheap)
sdk_add_include_directories(soft_crc)