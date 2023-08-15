load("@rules_cc//cc:defs.bzl", "cc_library")

licenses(["notice"])

cc_library(
    name = "fmt",
    hdrs = glob(["include/fmt/*.h"]),
    defines = ["FMT_HEADER_ONLY=1"],
    includes = ["include"],
    visibility = ["//visibility:public"],
)
