load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

licenses(["notice"])

filegroup(
    name = "all",
    srcs = glob(["**"]),
)

cmake(
    name = "libevent",
    visibility = ["//visibility:public"],
    cache_entries = {
        "EVENT__DISABLE_OPENSSL": "on",
        "EVENT__DISABLE_MBEDTLS": "on",
        "EVENT__DISABLE_REGRESS": "on",
        "EVENT__DISABLE_TESTS": "on",
        "EVENT__LIBRARY_TYPE": "STATIC",
        "_GNU_SOURCE": "on",
    },
    lib_source = ":all",
)