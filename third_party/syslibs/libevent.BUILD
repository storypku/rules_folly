load("@rules_cc//cc:defs.bzl", "cc_library")

licenses(["notice"])

cc_library(
    name = "libevent",
    linkopts = [
        "-levent",
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "libevent_boringssl",
    linkopts = [
        "-levent_boringssl",
    ],
    visibility = ["//visibility:public"],
    deps = [
        "@boringssl//:crypto",
    ],
)
