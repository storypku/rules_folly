load("@rules_cc//cc:defs.bzl", "cc_test")

package(
    default_visibility = ["//visibility:public"],
)

cc_test(
    name = "chrono_test",
    size = "small",
    srcs = ["chrono_test.cc"],
    deps = [
        "@com_google_googletest//:gtest_main",
        "@folly",
    ],
)

cc_test(
    name = "cpu_id_test",
    size = "small",
    srcs = ["cpu_id_test.cc"],
    deps = [
        "@com_google_googletest//:gtest_main",
        "@folly",
    ],
)

cc_test(
    name = "fingerprint_test",
    size = "small",
    srcs = ["fingerprint_test.cc"],
    deps = [
        "@com_github_google_glog//:glog",
        "@com_google_googletest//:gtest_main",
        "@folly",
    ],
)

cc_test(
    name = "checksum_test",
    size = "small",
    srcs = ["checksum_test.cc"],
    deps = [
        "@boost//:crc",
        "@com_github_google_glog//:glog",
        "@com_google_googletest//:gtest_main",
        "@folly",
    ],
)

cc_test(
    name = "random_test",
    size = "small",
    srcs = ["random_test.cc"],
    deps = [
        "@com_google_googletest//:gtest_main",
        "@folly",
    ],
)

# Enable this if enable_testing is True
# cc_test(
#     name = "small_vector_test",
#     size = "small",
#     srcs = ["small_vector_test.cc"],
#     deps = [
#         "@com_google_googletest//:gtest_main",
#         "@folly//:folly_test_support",
#     ],
# )
cc_test(
    name = "random_bm",
    size = "small",
    srcs = ["random_bm.cc"],
    deps = [
        "@folly//:follybenchmark",
    ],
)
