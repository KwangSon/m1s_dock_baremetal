sdk_generate_library()

sdk_library_add_sources(libc/vsnprintf.c)
sdk_library_add_sources(libc/syscalls.c)
sdk_library_add_sources(libc/printf.c)

# memheap
sdk_library_add_sources(mmheap/mmheap.c)
sdk_add_include_directories(mmheap)

# soft crc
sdk_library_add_sources(soft_crc/soft_crc.c)
sdk_add_include_directories(soft_crc)