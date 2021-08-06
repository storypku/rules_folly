# Optional Packages

## Disabled Dependencies

- LIBZ        zlib1g-dev        Enabled
- BZip2       libbz2-dev        Disabled
- LibLZMA     liblzma-dev       Disabled
- LZ4         liblz4-dev        Disabled
- ZSTD        libzstd-dev       Disabled
- LIBDWARF    libdwarf-dev      Disabled
- LIBUNWIND   libunwind-dev     Disabled
- LIBIBERTY   libiberty-dev     Disabled
- LIBAIO      libaio-dev        Disabled
- LIBURING    N/A               Disabled
- LIBSODIUM   libsodium-dev     Disabled

## Steps

1. Manage Folly tarball as git repository
2. Added the following section in `CMakeLists.txt`

```
set(CMAKE_VERBOSE_MAKEFILE ON)

if (BUILD_SHARED_LIBS)
    # set(CMAKE_POSITION_INDEPENDENT_CODE ON)
    add_compile_options("-fPIC")
endif (BUILD_SHARED_LIBS)
```

3. Run the following:
```
sudo apt autoremove \
    libiberty-dev \
    libbz2-dev \
    liblz4-dev \
    liblzma-dev \
    libzstd-dev \
    libjemalloc-dev \
    libunwind-dev
    libdwarf-dev \
    libsodium-dev \
    libaio-dev
cd build
cmake .. -DBUILD_SHARED_LIBS=ON -Wno-dev
```

Output:

```
-- Found gflags from package config /usr/lib/x86_64-linux-gnu/cmake/gflags/gflags-config.cmake
-- Found libevent: /usr/lib/x86_64-linux-gnu/libevent.so
-- Could NOT find BZip2 (missing: BZIP2_LIBRARIES BZIP2_INCLUDE_DIR)
-- Could NOT find LibLZMA (missing: LIBLZMA_LIBRARY LIBLZMA_INCLUDE_DIR LIBLZMA_HAS_AUTO_DECODER LIBLZMA_HAS_EASY_ENCODER LIBLZMA_HAS_LZMA_PRESET)
-- Could NOT find LZ4 (missing: LZ4_LIBRARY LZ4_INCLUDE_DIR)
-- Could NOT find ZSTD (missing: ZSTD_LIBRARY ZSTD_INCLUDE_DIR)
-- Could NOT find LIBDWARF (missing: LIBDWARF_LIBRARY LIBDWARF_INCLUDE_DIR)
-- Could NOT find LIBIBERTY (missing: LIBIBERTY_LIBRARY LIBIBERTY_INCLUDE_DIR)
-- Could NOT find LIBAIO (missing: LIBAIO_LIBRARY LIBAIO_INCLUDE_DIR)
-- Could NOT find LIBURING (missing: LIBURING_LIBRARY LIBURING_INCLUDE_DIR)
-- Could NOT find LIBSODIUM (missing: LIBSODIUM_LIBRARY LIBSODIUM_INCLUDE_DIR)
-- Could NOT find LIBUNWIND (missing: LIBUNWIND_LIBRARY LIBUNWIND_INCLUDE_DIR)
-- Setting FOLLY_USE_SYMBOLIZER: ON
-- Setting FOLLY_HAVE_ELF: 1
-- Setting FOLLY_HAVE_DWARF: FALSE
-- compiler has flag pclmul, setting compile flag for /work/github/folly-2021.08.23.00/folly/hash/detail/ChecksumDetail.cpp;/work/github/folly-2021.08.23.00/folly/hash/detail/Crc32CombineDetail.cpp;/work/github/folly-2021.08.23.00/folly/hash/detail/Crc32cDetail.cpp
-- Configuring done
-- Generating done
-- Build files have been written to: /work/github/folly-2021.08.23.00/build
```
