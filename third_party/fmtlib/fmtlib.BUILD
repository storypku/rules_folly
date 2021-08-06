load("@rules_cc//cc:defs.bzl", "cc_library")

# NOTE(jiaming): Adapted from
# https://github.com/pytorch/pytorch/blob/v1.9.0/third_party/fmt.BUILD

licenses(["notice"])  # Apache 2

cc_library(
    name = "fmt",
    hdrs = glob(["include/fmt/*.h",]),
    defines = ["FMT_HEADER_ONLY=1"],
    includes = ["include"],
    visibility = ["//visibility:public"],
)

