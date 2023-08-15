load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def folly_deps():
    """folly_deps sets up depencencies' git repositories folly depends on."""

    # TODO(pkomlev): add the following dependencies:
    # - lz4, lzma, xz compressions
    # - folly python support
    # - liburing et al.

    # TODO(pkomlev): the OpenSLL dependency is not hermetic, `libssl-dev` should
    # should be installed on the host running bazel builds.

    maybe(
        http_archive,
        name = "com_github_gflags_gflags",
        sha256 = "34af2f15cf7367513b352bdcd2493ab14ce43692d2dcd9dfc499492966c64dcf",
        strip_prefix = "gflags-2.2.2",
        urls = [
            "https://github.com/gflags/gflags/archive/v2.2.2.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "com_github_google_glog",
        sha256 = "8a83bf982f37bb70825df71a9709fa90ea9f4447fb3c099e1d720a439d88bad6",
        strip_prefix = "glog-0.6.0",
        urls = [
            "https://github.com/google/glog/archive/v0.6.0.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "double-conversion",
        strip_prefix = "double-conversion-3.3.0",
        sha256 = "04ec44461850abbf33824da84978043b22554896b552c5fd11a9c5ae4b4d296e",
        urls = ["https://github.com/google/double-conversion/archive/v3.3.0.tar.gz"],
    )

    maybe(
        http_archive,
        name = "zlib",
        strip_prefix = "zlib-1.2.13",
        build_file = "@com_github_storypku_rules_folly//third_party/zlib:zlib.BUILD",
        sha256 = "1525952a0a567581792613a9723333d7f8cc20b87a81f920fb8bc7e3f2251428",
        urls = ["https://github.com/madler/zlib/archive/v1.2.13.tar.gz"],
    )

    maybe(
        http_archive,
        name = "com_github_google_snappy",
        build_file = "@com_github_storypku_rules_folly//third_party/snappy:snappy.BUILD",
        strip_prefix = "snappy-1.1.10",
        sha256 = "49d831bffcc5f3d01482340fe5af59852ca2fe76c3e05df0e67203ebbe0f1d90",
        urls = [
            "https://github.com/google/snappy/archive/1.1.10.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "com_github_libevent_libevent",
        sha256 = "7180a979aaa7000e1264da484f712d403fcf7679b1e9212c4e3d09f5c93efc24",
        urls = ["https://github.com/libevent/libevent/archive/release-2.1.12-stable.tar.gz"],
        strip_prefix = "libevent-release-2.1.12-stable",
        build_file = "@com_github_storypku_rules_folly//third_party/libevent:libevent.BUILD",
    )

    maybe(
        http_archive,
        name = "com_github_fmtlib_fmt",
        urls = ["https://github.com/fmtlib/fmt/archive/10.1.0.tar.gz"],
         sha256 = "deb0a3ad2f5126658f2eefac7bf56a042488292de3d7a313526d667f3240ca0a",
        strip_prefix = "fmt-10.1.0",
        build_file = "@com_github_storypku_rules_folly//third_party/fmtlib:fmtlib.BUILD",
    )

    rules_boost_commit = "cfa585b1b5843993b70aa52707266dc23b3282d0"
    maybe(
        http_archive,
        name = "com_github_nelhage_rules_boost",
        sha256 = "a7c42df432fae9db0587ff778d84f9dc46519d67a984eff8c79ae35e45f277c1", 
        strip_prefix = "rules_boost-{}".format(rules_boost_commit),
        urls = [
            "https://github.com/nelhage/rules_boost/archive/{}.tar.gz".format(rules_boost_commit),
        ],
    )

    maybe(
        native.new_local_repository,
        name = "openssl",
        path = "/usr/include",
        build_file = "@com_github_storypku_rules_folly//third_party/syslibs:openssl.BUILD",
    )

    gtest_version = "1.14.0"
    maybe(
        http_archive,
        name = "com_google_googletest",
        strip_prefix = "googletest-{}".format(gtest_version),
        urls = [
            "https://github.com/google/googletest/archive/refs/tags/v{}.tar.gz".format(gtest_version),
        ],
    )

    folly_version = "2023.08.14.00"
    http_archive(
        name = "folly",
        build_file_content = """
package(default_visibility = ["//visibility:public"])

load("@com_github_storypku_rules_folly//bazel:folly.bzl", "folly_library", "folly_testing")

folly_library("folly")
folly_testing("folly")
""",
        strip_prefix = "folly-{}".format(folly_version),
        sha256 = "63b0abc6860e91651484937fbb6e90a05dbf48b30133b56846e5e6b9d13c396c",
        urls = [
            "https://github.com/facebook/folly/archive/v{}.tar.gz".format(folly_version),
        ],
        patch_args = ["-p1"],
        patches = [
            "@com_github_storypku_rules_folly//third_party/folly:p00_double_conversion_include_fix.patch",
        ],
    )
