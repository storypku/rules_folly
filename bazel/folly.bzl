# Implement a macro folly_library() that the BUILD file can load.
load("@rules_cc//cc:defs.bzl", "cc_library")

# Ref: https://github.com/google/glog/blob/v0.5.0/bazel/glog.bzl
def expand_template_impl(ctx):
    ctx.actions.expand_template(
        template = ctx.file.template,
        output = ctx.outputs.out,
        substitutions = ctx.attr.substitutions,
    )

expand_template = rule(
    implementation = expand_template_impl,
    attrs = {
        "template": attr.label(mandatory = True, allow_single_file = True),
        "substitutions": attr.string_dict(mandatory = True),
        "out": attr.output(mandatory = True),
    },
)

def dict_union(x, y):
    z = {}
    z.update(x)
    z.update(y)
    return z

def _val(predicate):
    return "1" if predicate else "0"

def folly_library(
        with_gflags = True,
        with_jemalloc = False,
        with_bz2 = False,
        with_lzma = False,
        with_lz4 = False,
        with_zstd = False,
        with_libiberty = False,
        with_libunwind = False,
        with_libdwarf = False,
        with_libaio = False,
        with_liburing = False):
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

        common_defs = {
            "@FOLLY_HAVE_PTHREAD@": "1",
            "@FOLLY_HAVE_PTHREAD_ATFORK@": "1",
            "@FOLLY_HAVE_MEMRCHR@": "1",
            "@FOLLY_HAVE_ACCEPT4@": "1",
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
            "@FOLLY_HAVE_INT128_T@": "1",
            "@FOLLY_SUPPLY_MISSING_INT128_TRAITS@": "0",
            "@FOLLY_HAVE_WCHAR_SUPPORT@": "1",
            "@FOLLY_HAVE_EXTRANDOM_SFMT19937@": "1",
            "@HAVE_VSNPRINTF_ERRORS@": "1",
            "@FOLLY_HAVE_SHADOW_LOCAL_WARNINGS@": "1",
            "@FOLLY_SUPPORT_SHARED_LIBRARY@": "1",
        }

    total_defs = dict_union(common_defs, {
        "@FOLLY_USE_LIBSTDCPP@": "1",
        "@FOLLY_USE_LIBCPP@": "0",
        "@FOLLY_LIBRARY_SANITIZE_ADDRESS@": "0",
        "@FOLLY_HAVE_LIBSNAPPY@": "1",
        "@FOLLY_HAVE_LIBZ@": "1",
        "@FOLLY_GFLAGS_NAMESPACE@": "gflags",
        "@FOLLY_HAVE_LIBGLOG@": "1",
        "@FOLLY_UNUSUAL_GFLAGS_NAMESPACE@": "0",
        "@FOLLY_HAVE_LIBGFLAGS@": _val(with_gflags),
        "@FOLLY_USE_JEMALLOC@": _val(with_jemalloc),
        "@FOLLY_USE_SYMBOLIZER@": _val(with_libdwarf),
        "@FOLLY_HAVE_LIBLZ4@": _val(with_lz4),
        "@FOLLY_HAVE_LIBLZMA@": _val(with_lzma),
        "@FOLLY_HAVE_LIBZSTD@": _val(with_zstd),
        "@FOLLY_HAVE_LIBBZ2@": _val(with_bz2),
    })

    native.genrule(
        name = "folly_config_in_h",
        srcs = [
            "CMake/folly-config.h.cmake",
        ],
        outs = [
            "folly/folly-config.h.in",
        ],
        cmd = "$(location @rules_folly//bazel:generate_config_in.sh) < $< > $@",
        tools = ["@rules_folly//bazel:generate_config_in.sh"],
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
        cmd = "$(location @rules_folly//bazel:strip_config_h.sh) < $< > $@",
        tools = ["@rules_folly//bazel:strip_config_h.sh"],
    )

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
            "-ldl",
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
