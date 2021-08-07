# Implement a macro folly_library() that the BUILD file can load.
load("@rules_cc//cc:defs.bzl", "cc_library")

def folly_library(
        with_bz2 = False,
        with_lzma = False,
        with_lz4 = False,
        with_zstd = False,
        with_libiberty = False,
        with_libunwind = False,
        with_libdwarf = False,
        with_libaio = False,
        with_liburing = False):
    native.genrule(
        name = "folly_config_h",
        srcs = [
            "@rules_folly//folly:folly-config.h",
        ],
        outs = [
            "folly/folly-config.h",
        ],
        cmd = "cat $(<) > $(@)",
    )

    # Exclude tests, benchmarks, and other standalone utility executables from the
    # library sources.  Test sources are listed separately below.
    common_excludes = [
        "folly/build/**",
        "folly/experimental/exception_tracer/**",
        "folly/experimental/pushmi/**",
        "folly/futures/exercises/**",
        "folly/logging/example/**",
        "folly/test/**",
        "folly/**/test/**",
        "folly/tools/**",
    ]

    hdrs = native.glob(["folly/**/*.h"], exclude = common_excludes + [
        "folly/python/fibers.h",
        "folly/python/GILAwareManualExecutor.h",
    ])
    srcs = native.glob(["folly/**/*.cpp"], exclude = common_excludes + [
        "folly/**/*Benchmark.cpp",
        "folly/**/*Test.cpp",
        "folly/experimental/JSONSchemaTester.cpp",
        "folly/experimental/io/HugePageUtil.cpp",
        "folly/python/fibers.cpp",
        "folly/python/GILAwareManualExecutor.cpp",
        "folly/cybld/folly/executor.cpp",
    ])

    # Explicitly include utility library code from inside
    # test subdirs
    hdrs = hdrs + [
        "folly/container/test/F14TestUtil.h",
        "folly/container/test/TrackingTypes.h",
        "folly/io/async/test/AsyncSSLSocketTest.h",
        "folly/io/async/test/AsyncSocketTest.h",
        "folly/io/async/test/AsyncSocketTest2.h",
        "folly/io/async/test/BlockingSocket.h",
        "folly/io/async/test/MockAsyncSocket.h",
        "folly/io/async/test/MockAsyncServerSocket.h",
        "folly/io/async/test/MockAsyncSSLSocket.h",
        "folly/io/async/test/MockAsyncTransport.h",
        "folly/io/async/test/MockAsyncUDPSocket.h",
        "folly/io/async/test/MockTimeoutManager.h",
        "folly/io/async/test/ScopedBoundPort.h",
        "folly/io/async/test/SocketPair.h",
        "folly/io/async/test/TestSSLServer.h",
        "folly/io/async/test/TimeUtil.h",
        "folly/io/async/test/UndelayedDestruction.h",
        "folly/io/async/test/Util.h",
        "folly/synchronization/test/Semaphore.h",
        "folly/test/DeterministicSchedule.h",
        "folly/test/JsonTestUtil.h",
        "folly/test/TestUtils.h",
    ]

    srcs = srcs + [
        "folly/io/async/test/ScopedBoundPort.cpp",
        "folly/io/async/test/SocketPair.cpp",
        "folly/io/async/test/TimeUtil.cpp",
    ]

    # Exclude specific sources if we do not have third-party libraries
    # required to build them
    common_excludes = []

    # NOTE(storypku): hardcode with_libsodium to False for now
    hdrs_excludes = [
        "folly/experimental/crypto/Blake2xb.h",
        "folly/experimental/crypto/detail/LtHashInternal.h",
        "folly/experimental/crypto/LtHash-inl.h",
        "folly/experimental/crypto/LtHash.h",
    ]

    srcs_excludes = [
        "folly/experimental/crypto/Blake2xb.cpp",
        "folly/experimental/crypto/detail/MathOperation_AVX2.cpp",
        "folly/experimental/crypto/detail/MathOperation_Simple.cpp",
        "folly/experimental/crypto/detail/MathOperation_SSE2.cpp",
        "folly/experimental/crypto/LtHash.cpp",
    ]

    # Excerpt from <TOP-DIR>/CMake/folly-deps.cmake
    # check_function_exists(backtrace FOLLY_HAVE_BACKTRACE)
    # if (FOLLY_HAVE_ELF_H AND FOLLY_HAVE_BACKTRACE AND LIBDWARF_FOUND)
    # set(FOLLY_USE_SYMBOLIZER ON)
    # Question: with_libdwarf is equivalent to use_symbolizer ?
    if with_libdwarf == False:
        common_excludes = common_excludes + [
            "folly/experimental/symbolizer/**",
        ]
        srcs_excludes = srcs_excludes + [
            "folly/SingletonStackTrace.cpp",
        ]

    if with_libaio == False:
        hdrs_excludes = hdrs_excludes + [
            "folly/experimental/io/AsyncIO.h",
        ]
        srcs_excludes = srcs_excludes + [
            "folly/experimental/io/AsyncIO.cpp",
        ]

    if with_liburing == False:
        hdrs_excludes = hdrs_excludes + [
            "folly/experimental/io/IoUring.h",
        ]
        srcs_excludes = srcs_excludes + [
            "folly/experimental/io/IoUring.cpp",
        ]

    if with_libaio == False and with_liburing == False:
        hdrs_excludes = hdrs_excludes + [
            "folly/experimental/io/AsyncBase.h",
        ]
        srcs_excludes = srcs_excludes + [
            "folly/experimental/io/AsyncBase.cpp",
        ]

    # CHECK_CXX_COMPILER_FLAG(-mpclmul COMPILER_HAS_M_PCLMUL)
    cc_library(
        name = "folly",
        hdrs = ["folly_config_h"] +
               native.glob(hdrs, exclude = common_excludes + hdrs_excludes),
        srcs = native.glob(srcs, exclude = common_excludes + srcs_excludes),
        copts = [
            "-fPIC",
            "-faligned-new",
            "-fopenmp",
            "-Wall",
            "-Wno-deprecated",
            "-Wno-deprecated-declarations",
            "-Wno-sign-compare",
            "-Wno-unused",
            "-Wunused-label",
            "-Wunused-result",
            "-Wshadow-compatible-local",
            "-Wno-noexcept-type",
            "-std=gnu++14",
        ] + select({
            ":linux_x86_64": ["-mpclmul"],
            "//conditions:default": [],
        }),
        includes = ["."],
        linkopts = [
            "-pthread",
        ],
        # Ref: https://docs.bazel.build/versions/main/be/c-cpp.html#cc_library.linkstatic
        linkstatic = True,
        visibility = ["//visibility:public"],
        deps = [
            "@boost//:algorithm",
            "@boost//:config",
            "@boost//:container",
            "@boost//:context",
            "@boost//:conversion",
            "@boost//:crc",
            "@boost//:filesystem",
            "@boost//:intrusive",
            "@boost//:iterator",
            "@boost//:multi_index",
            "@boost//:operators",
            "@boost//:program_options",
            "@boost//:regex",
            "@boost//:type_traits",
            "@boost//:utility",
            "@boost//:variant",
            "@com_github_gflags_gflags//:gflags",
            "@com_github_google_glog//:glog",
            "@com_github_google_snappy//:snappy",
            "@com_github_libevent_libevent//:libevent",
            "@double-conversion//:double-conversion",
            "@openssl//:ssl",
        ],
    )
