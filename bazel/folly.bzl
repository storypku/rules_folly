# Implement a macro folly_library() that the BUILD file can load.
load("@rules_cc//cc:defs.bzl", "cc_library")

# Ref: https://github.com/google/glog/blob/v0.5.0/bazel/glog.bzl
def _expand_template_impl(ctx):
    ctx.actions.expand_template(
        template = ctx.file.template,
        output = ctx.outputs.out,
        substitutions = ctx.attr.substitutions,
    )

expand_template = rule(
    implementation = _expand_template_impl,
    attrs = {
        "template": attr.label(mandatory = True, allow_single_file = True),
        "substitutions": attr.string_dict(mandatory = True),
        "out": attr.output(mandatory = True),
    },
)

def _dict_union(x, y):
    z = {}
    z.update(x)
    z.update(y)
    return z

def folly_library(
        with_gflags = 1,
        with_jemalloc = 0,
        with_bz2 = 0,
        with_lzma = 0,
        with_lz4 = 0,
        with_zstd = 0,
        with_unwind = 0,
        with_dwarf = 0,
        with_libaio = 1,
        with_liburing = 1,
        enable_testing = 0):
    # Exclude tests, benchmarks, and other standalone utility executables from the
    # library sources.  Test sources are listed separately below.
    common_excludes = [
        "folly/build/**",
        "folly/logging/example/**",
        "folly/tools/**",
        "folly/docs/**",

    ]

    hdrs = native.glob(["folly/**/*.h"], exclude = common_excludes + [
        "folly/test/**/*.h",
        "folly/**/test/**/*.h",
        "folly/python/fibers.h",
        "folly/python/GILAwareManualExecutor.h",
    ])
    srcs = native.glob(["folly/**/*.cpp"], exclude = common_excludes + [
        "folly/Benchmark.cpp",
        "folly/test/**/*.cpp",
        "folly/**/test/**/*.cpp",
        "folly/**/*Test.cpp",
        "folly/experimental/JSONSchemaTester.cpp",
        "folly/experimental/io/HugePageUtil.cpp",
        "folly/python/error.cpp",
        "folly/python/executor.cpp",
        "folly/python/fibers.cpp",
        "folly/python/GILAwareManualExecutor.cpp",
        "folly/cybld/folly/executor.cpp",
        "folly/experimental/symbolizer/Addr2Line.cpp",
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

    # NOTE(storypku): hardcode with_libsodium set to False for now
    # Ref: https://github.com/facebook/folly/blob/v2021.09.06.00/CMakeLists.txt#L270
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

    if with_libaio == 0:
        hdrs_excludes = hdrs_excludes + [
            "folly/experimental/io/AsyncIO.h",
        ]
        srcs_excludes = srcs_excludes + [
            "folly/experimental/io/AsyncIO.cpp",
        ]

    if with_liburing == 0:
        hdrs_excludes = hdrs_excludes + [
            "folly/experimental/io/IoUring.h",
            "folly/experimental/io/IoUringEvent.h",
            "folly/experimental/io/IoUringBackend.h",
        ]
        srcs_excludes = srcs_excludes + [
            "folly/experimental/io/IoUring.cpp",
            "folly/experimental/io/IoUringEvent.cpp",
            "folly/experimental/io/IoUringBackend.cpp",
        ]
    if with_libaio == 0 and with_liburing == 0:
        hdrs_excludes = hdrs_excludes + [
            "folly/experimental/io/AsyncBase.h",
            "folly/experimental/io/PollIoBackend.h",
            "folly/experimental/io/SimpleAsyncIO.h",
        ]
        srcs_excludes = srcs_excludes + [
            "folly/experimental/io/AsyncBase.cpp",
            "folly/experimental/io/PollIoBackend.cpp",
            "folly/experimental/io/SimpleAsyncIO.cpp",
        ]

    # NOTE(storypku):
    # Compare header and source files with that of CMake
    # my_hdrs = native.glob(hdrs, exclude = common_excludes + hdrs_excludes)
    # print("=== # of headers: {} ===".format(len(my_hdrs)))
    # print("===== HEADERS END =====")
    # my_srcs = native.glob(srcs, exclude = common_excludes + srcs_excludes)
    # print("=== # of srcs: {} ===".format(len(my_srcs)))
    # for my_src in my_srcs:
    #    print(my_src)
    # print("===== SRCS END =====")
    if with_gflags == 0:
        hdrs_excludes = hdrs_excludes + [
            "folly/experimental/NestedCommandLineApp.h",
            "folly/experimental/ProgramOptions.h",
        ]
        srcs_excludes = srcs_excludes + [
            "folly/experimental/NestedCommandLineApp.cpp",
            "folly/experimental/ProgramOptions.cpp",
        ]

    # TODO(jiaming)
    common_defs = {
        "@FOLLY_HAVE_PTHREAD@": "1",
        "@FOLLY_HAVE_PTHREAD_ATFORK@": "1",
        "@FOLLY_HAVE_ACCEPT4@": "1",
        "@FOLLY_HAVE_GETRANDOM@": "1",
        "@FOLLY_HAVE_PREADV@": "1",
        "@FOLLY_HAVE_PWRITEV@": "1",
        "@FOLLY_HAVE_CLOCK_GETTIME@": "1",
        "@FOLLY_HAVE_PIPE2@": "1",
        "@FOLLY_HAVE_SENDMMSG@": "1",
        "@FOLLY_HAVE_RECVMMSG@": "1",
        "@FOLLY_HAVE_OPENSSL_ASN1_TIME_DIFF@": "1",
        "@FOLLY_HAVE_IFUNC@": "1",
        "@FOLLY_HAVE_STD__IS_TRIVIALLY_COPYABLE@": "1",
        "@FOLLY_HAVE_UNALIGNED_ACCESS@": "1",
        "@FOLLY_HAVE_VLA@": "1",
        "@FOLLY_HAVE_WEAK_SYMBOLS@": "1",
        "@FOLLY_HAVE_LINUX_VDSO@": "1",
        "@FOLLY_HAVE_MALLOC_USABLE_SIZE@": "1",
        "@FOLLY_HAVE_INT128_T@": "0",
        "@FOLLY_HAVE_WCHAR_SUPPORT@": "1",
        "@define FOLLY_HAVE_EXTRANDOM_SFMT19937@": "1",
        "@HAVE_VSNPRINTF_ERRORS@": "1",
        "@FOLLY_HAVE_SHADOW_LOCAL_WARNINGS@": "1",
        "@FOLLY_SUPPORT_SHARED_LIBRARY@": "1",
        "@FOLLY_DEMANGLE_MAX_SYMBOL_SIZE": "1024",
    }

    # Note(storypku):
    total_defs = _dict_union(common_defs, {
        "@FOLLY_USE_LIBSTDCPP@": "1",
        "@FOLLY_USE_LIBCPP@": "0",
        "@FOLLY_HAVE_LIBGFLAGS@": str(with_gflags),
        "@FOLLY_UNUSUAL_GFLAGS_NAMESPACE@": "0",
        "@FOLLY_GFLAGS_NAMESPACE@": "gflags",
        "@FOLLY_HAVE_LIBGLOG@": "1",
        "@FOLLY_HAVE_LIBLZ4@": str(with_lz4),
        "@FOLLY_HAVE_LIBLZMA@": str(with_lzma),
        "@FOLLY_HAVE_LIBSNAPPY@": "0",
        "@FOLLY_HAVE_LIBZ@": "1",
        "@FOLLY_HAVE_LIBZSTD@": str(with_zstd),
        "@FOLLY_HAVE_LIBBZ2@": str(with_bz2),
        "@FOLLY_USE_JEMALLOC@": str(with_jemalloc),
        "@FOLLY_HAVE_LIBUNWIND@": str(with_unwind),
        "@FOLLY_HAVE_DWARF@": str(with_dwarf),
        "@FOLLY_HAVE_ELF@": "1",
        "@FOLLY_HAVE_SWAPCONTEXT@": "1",
        "@FOLLY_HAVE_BACKTRACE@": "1",
        "@FOLLY_USE_SYMBOLIZER@": "1",
        "@FOLLY_LIBRARY_SANITIZE_ADDRESS@": "0",
        "@FOLLY_HAVE_LIBRT@": "0",
    })

    native.genrule(
        name = "folly_config_in_h",
        srcs = [
            "CMake/folly-config.h.cmake",
        ],
        outs = [
            "folly/folly-config.h.in",
        ],
        cmd = "$(location @com_github_storypku_rules_folly//bazel:generate_config_in.sh) < $< > $@",
        tools = ["@com_github_storypku_rules_folly//bazel:generate_config_in.sh"],
    )

    expand_template(
        name = "folly_config_h_unstripped",
        template = "folly/folly-config.h.in",
        out = "folly/folly-config.h.unstripped",
        substitutions = total_defs,
    )

    native.genrule(
        name = "folly_config_h",
        srcs = [
            "folly/folly-config.h.unstripped",
        ],
        outs = [
            "folly/folly-config.h",
        ],
        cmd = "$(location @com_github_storypku_rules_folly//bazel:strip_config_h.sh) < $< > $@",
        tools = ["@com_github_storypku_rules_folly//bazel:strip_config_h.sh"],
    )

    common_copts = [
        "-std=gnu++1z",
        "-fPIC",
        "-finput-charset=UTF-8",
        "-fsigned-char",
        "-fopenmp",
        "-faligned-new",
        "-Wall",
        "-Wno-deprecated",
        "-Wno-deprecated-declarations",
        "-Wno-sign-compare",
        "-Wno-unused",
        "-Wunused-label",
        "-Wunused-result",
        "-Wshadow-compatible-local",
        "-Wno-noexcept-type",
    ]

    # CHECK_CXX_COMPILER_FLAG(-mpclmul COMPILER_HAS_M_PCLMUL)
    cc_library(
        name = "folly",
        hdrs = ["folly_config_h"] +
               native.glob(hdrs, exclude = common_excludes + hdrs_excludes),
        srcs = native.glob(srcs, exclude = common_excludes + srcs_excludes),
        copts = common_copts + select({
            "@com_github_storypku_rules_folly//bazel:linux_x86_64": ["-mpclmul"],
            "//conditions:default": [],
        }),
        includes = ["."],
        linkopts = [
            "-pthread",
            "-ldl",
            "-lstdc++fs",
        ],
        # if (FOLLY_STDLIB_LIBSTDCXX AND NOT FOLLY_STDLIB_LIBSTDCXX_GE_9)
        # list (APPEND CMAKE_REQUIRED_LIBRARIES stdc++fs)
        # list (APPEND FOLLY_LINK_LIBRARIES stdc++fs)
        # endif()
        # if (FOLLY_STDLIB_LIBCXX AND NOT FOLLY_STDLIB_LIBCXX_GE_9)
        # list (APPEND CMAKE_REQUIRED_LIBRARIES c++fs)
        # list (APPEND FOLLY_LINK_LIBRARIES c++fs)
        # endif ()
        # Ref: https://docs.bazel.build/versions/main/be/c-cpp.html#cc_library.linkstatic
        # linkstatic = True,
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
            "@com_github_google_glog//:glog",
            "@com_github_google_snappy//:snappy",
            "@com_github_libevent_libevent//:libevent",
            "@com_github_fmtlib_fmt//:fmt",
            "@double-conversion//:double-conversion",
            "@boringssl//:ssl",
        ] + ([
            "@com_github_gflags_gflags//:gflags",
        ] if with_gflags else []),
    )

    cc_library(
        name = "follybenchmark",
        srcs = ["folly/Benchmark.cpp"],
        deps = [
            ":folly",
        ],
        copts = common_copts,
    )

    if enable_testing:
        cc_library(
            name = "folly_test_support",
            srcs = [
                "folly/test/common/TestMain.cpp",
                "folly/test/FBVectorTestUtil.cpp",
                "folly/test/DeterministicSchedule.cpp",
                "folly/test/SingletonTestStructs.cpp",
                "folly/test/SocketAddressTestHelper.cpp",
                "folly/experimental/test/CodingTestUtils.cpp",
                "folly/futures/test/TestExecutor.cpp",
                "folly/io/async/test/ScopedBoundPort.cpp",
                "folly/io/async/test/SocketPair.cpp",
                "folly/logging/test/ConfigHelpers.cpp",
                "folly/logging/test/TestLogHandler.cpp",
                "folly/io/async/test/SSLUtil.cpp",
                "folly/io/async/test/TestSSLServer.cpp",
                "folly/io/async/test/TimeUtil.cpp",
            ],
            hdrs = [
                "folly/test/FBVectorTestUtil.h",
                "folly/test/DeterministicSchedule.h",
                "folly/test/SingletonTestStructs.h",
                "folly/test/SocketAddressTestHelper.h",
                "folly/container/test/F14TestUtil.h",
                "folly/container/test/TrackingTypes.h",
                "folly/experimental/test/CodingTestUtils.h",
                "folly/futures/test/TestExecutor.h",
                "folly/io/async/test/BlockingSocket.h",
                "folly/io/async/test/MockAsyncServerSocket.h",
                "folly/io/async/test/MockAsyncSocket.h",
                "folly/io/async/test/MockAsyncSSLSocket.h",
                "folly/io/async/test/MockAsyncTransport.h",
                "folly/io/async/test/MockAsyncUDPSocket.h",
                "folly/io/async/test/MockTimeoutManager.h",
                "folly/io/async/test/ScopedBoundPort.h",
                "folly/io/async/test/SocketPair.h",
                "folly/io/async/test/SSLUtil.h",
                "folly/io/async/test/TestSSLServer.h",
                "folly/io/async/test/TimeUtil.h",
                "folly/io/async/test/UndelayedDestruction.h",
                "folly/io/async/test/Util.h",
                "folly/logging/test/ConfigHelpers.h",
                "folly/logging/test/TestLogHandler.h",
            ],
            deps = [
                ":follybenchmark",
                "@com_github_google_glog//:glog",
                "@com_google_googletest//:gtest",
                "@com_google_googletest//:gtest_main",
                "@boringssl//:ssl",
            ],
        )
