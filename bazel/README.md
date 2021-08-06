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
