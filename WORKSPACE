workspace(name = "rules_folly")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//bazel:folly_deps.bzl", "folly_deps")

folly_deps()

load("@com_github_nelhage_rules_boost//:boost/boost.bzl", "boost_deps")

boost_deps()

http_archive(
    name = "com_google_googletest",
    sha256 = "b4870bf121ff7795ba20d20bcdd8627b8e088f2d1dab299a031c1034eddc93d5",
    strip_prefix = "googletest-release-1.11.0",
    urls = [
        "https://github.com/google/googletest/archive/release-1.11.0.tar.gz",
    ],
)
