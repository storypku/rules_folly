package(
    default_visibility = ["//visibility:public"],
)

exports_files([
    "generate_config_in.sh",
    "strip_config_h.sh",
])

config_setting(
    name = "linux_aarch64",
    constraint_values = [
        "@bazel_tools//platforms:linux",
        "@bazel_tools//platforms:aarch64",
    ],
)

config_setting(
    name = "linux_x86_64",
    constraint_values = [
        "@bazel_tools//platforms:linux",
        "@bazel_tools//platforms:x86_64",
    ],
)
