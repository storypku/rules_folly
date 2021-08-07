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
    name = "mpmc_queue_test",
    size = "small",
    srcs = ["mpmc_queue_test.cc"],
    deps = [
        "@boost//:intrusive_ptr",
        "@boost//:thread",
        "@com_google_googletest//:gtest_main",
        "@folly",
    ],
)
