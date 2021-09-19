load("@com_github_storypku_rules_folly//bazel:folly.bzl", "folly_library")

package(default_visibility = ["//visibility:public"])

config_setting(
    name = "linux_aarch64",
    constraint_values = [
        "@bazel_tools//platforms:linux",
        "@bazel_tools//platforms:aarch64",
    ],
    visibility = ["//visibility:public"],
)

config_setting(
    name = "linux_x86_64",
    constraint_values = [
        "@bazel_tools//platforms:linux",
        "@bazel_tools//platforms:x86_64",
    ],
    visibility = ["//visibility:public"],
)

folly_library()
