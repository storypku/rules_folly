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
    name = "libevent_openssl",
    linkopts = [
        "-levent_openssl",
    ],
    visibility = ["//visibility:public"],
    deps = [
        "@openssl//:crypto",
    ],
)
