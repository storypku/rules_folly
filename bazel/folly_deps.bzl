load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def folly_deps(with_gflags = 1, with_syslibs = 0):
    if with_gflags:
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
        strip_prefix = "glog-0.5.0",
        build_file_content = """
load(":bazel/glog.bzl", "glog_library")
glog_library(with_gflags = {})
""".format(with_gflags),
        sha256 = "eede71f28371bf39aa69b45de23b329d37214016e2055269b3b5e7cfd40b59f5",
        urls = [
            "https://github.com/google/glog/archive/v0.5.0.tar.gz",
        ],
    )

    if with_syslibs:
        maybe(
            native.new_local_repository,
            name = "double-conversion",
            path = "/usr/include",
            build_file = "@com_github_zhuangAnjun_rules_folly//third_party/syslibs:double-conversion.BUILD",
        )
    else:
        maybe(
            http_archive,
            name = "double-conversion",
            strip_prefix = "double-conversion-3.1.5",
            sha256 = "a63ecb93182134ba4293fd5f22d6e08ca417caafa244afaa751cbfddf6415b13",
            urls = ["https://github.com/google/double-conversion/archive/v3.1.5.tar.gz"],
        )

    if with_syslibs:
        maybe(
            native.new_local_repository,
            name = "zlib",
            path = "/usr/include",
            build_file = "@com_github_zhuangAnjun_rules_folly//third_party/syslibs:zlib.BUILD",
        )
    else:
        maybe(
            http_archive,
            name = "zlib",
            sha256 = "629380c90a77b964d896ed37163f5c3a34f6e6d897311f1df2a7016355c45eff",
            strip_prefix = "zlib-1.2.11",
            build_file = "@com_github_zhuangAnjun_rules_folly//third_party/zlib:zlib.BUILD",
            urls = ["https://github.com/madler/zlib/archive/v1.2.11.tar.gz"],
        )

    if with_syslibs:
        maybe(
            native.new_local_repository,
            name = "com_github_google_snappy",
            path = "/usr/include",
            build_file = "@com_github_zhuangAnjun_rules_folly//third_party/syslibs:snappy.BUILD",
        )
    else:
        maybe(
            http_archive,
            name = "com_github_google_snappy",
            build_file = "@com_github_zhuangAnjun_rules_folly//third_party/snappy:snappy.BUILD",
            strip_prefix = "snappy-1.1.9",
            sha256 = "75c1fbb3d618dd3a0483bff0e26d0a92b495bbe5059c8b4f1c962b478b6e06e7",
            urls = [
                "https://github.com/google/snappy/archive/1.1.9.tar.gz",
            ],
        )

    # ===== libevent (libevent.org) dependency =====
    if with_syslibs:
        maybe(
            native.new_local_repository,
            name = "com_github_libevent_libevent",
            path = "/usr/include",
            build_file = "@com_github_zhuangAnjun_rules_folly//third_party/syslibs:libevent.BUILD",
        )
    else:
        maybe(
            http_archive,
            name = "com_github_libevent_libevent",
            sha256 = "316ddb401745ac5d222d7c529ef1eada12f58f6376a66c1118eee803cb70f83d",
            urls = ["https://github.com/libevent/libevent/archive/release-2.1.8-stable.tar.gz"],
            strip_prefix = "libevent-release-2.1.8-stable",
            build_file = "@com_github_zhuangAnjun_rules_folly//third_party/libevent:libevent.BUILD",
        )

    maybe(
        http_archive,
        name = "com_github_fmtlib_fmt",
        urls = ["https://github.com/fmtlib/fmt/archive/8.0.1.tar.gz"],
        sha256 = "b06ca3130158c625848f3fb7418f235155a4d389b2abc3a6245fb01cb0eb1e01",
        strip_prefix = "fmt-8.0.1",
        build_file = "@com_github_zhuangAnjun_rules_folly//third_party/fmtlib:fmtlib.BUILD",
    )

    # Note(jiaming):
    # Here we choose the latest (as of 08.04.2021) version of rules_boost as
    # AArch64 support was only complete in recent versions. We had to resolve
    # all build errors caused by API changes since Boost 1.69+ and refactored
    # HttpProxy implementation as it was dependent on Boost.Beast.
    # PS: Use of git_repository is discouraged. Ref:
    # https://docs.bazel.build/versions/main/external.html#repository-rules
    rules_boost_commit = "fb9f3c9a6011f966200027843d894923ebc9cd0b"
    maybe(
        http_archive,
        name = "com_github_nelhage_rules_boost",
        sha256 = "046f774b185436d506efeef8be6979f2c22f1971bfebd0979bafa28088bf28d0",
        strip_prefix = "rules_boost-{}".format(rules_boost_commit),
        urls = [
            "https://github.com/nelhage/rules_boost/archive/{}.tar.gz".format(rules_boost_commit),
        ],
    )


     # maybe(
     #     native.new_local_repository,
     #     name = "openssl",
     #     path = "/usr/include",
     #     build_file = "@com_github_zhuangAnjun_rules_folly//third_party/syslibs:openssl.BUILD",
     # )
    maybe(
      http_archive,
      name = "openssl",
      strip_prefix = "openssl-openssl-3.0.6",
      build_file = "@com_github_zhuangAnjun_rules_folly//third_party/syslibs:openssl.BUILD",
      urls = [
        "https://github.com/openssl/openssl/archive/refs/tags/openssl-3.0.6.tar.gz",
      ],
    )
    gtest_version = "1.11.0"
    maybe(
        http_archive,
        name = "com_google_googletest",
        sha256 = "b4870bf121ff7795ba20d20bcdd8627b8e088f2d1dab299a031c1034eddc93d5",
        strip_prefix = "googletest-release-{}".format(gtest_version),
        urls = [
            "https://github.com/google/googletest/archive/refs/tags/release-{}.tar.gz".format(gtest_version),
        ],
    )

    # NOTE(storypku): The following failed with error:
    # external/folly/folly/ssl/OpenSSLVersionFinder.h:29:26:
    # error: 'OPENSSL_VERSION' was not declared in this scope
    # 29 |   return OpenSSL_version(OPENSSL_VERSION);
    # maybe(
    #    http_archive,
    #    name = "openssl",
    #    sha256 = "17f5e63875d592ac8f596a6c3d579978a7bf943247c1f8cbc8051935ea42b3e5",
    #    strip_prefix = "boringssl-b3d98af9c80643b0a36d495693cc0e669181c0af",
    #    urls = ["https://github.com/google/boringssl/archive/b3d98af9c80643b0a36d495693cc0e669181c0af.tar.gz"],
    # )
    # TODO(storypku): Ref: https://github.com/google/glog/blob/master/bazel/glog.bzl
    folly_version = "2022.11.14.00"
    http_archive(
        name = "folly",
        # build_file = "@com_github_zhuangAnjun_rules_folly//third_party/folly:folly.BUILD",
        build_file_content = """
load("@com_github_zhuangAnjun_rules_folly//bazel:folly.bzl", "folly_library")
package(default_visibility = ["//visibility:public"])
folly_library(with_gflags = {})
""".format(with_gflags),
        strip_prefix = "folly-{}".format(folly_version),
        # sha256 = "8fb0a5392cbf6da1233c59933fff880dd77bbe61e0e2d578347ff436c776eda5",
        urls = [
             "https://github.com/facebook/folly/archive/refs/tags/v{}.tar.gz".format(folly_version),
        ],
        patch_args = ["-p1"],
        patches = [
            "@com_github_zhuangAnjun_rules_folly//third_party/folly:folly_2022_11_14_00.patch",
        ],
    )
    http_archive(
        name = "boringssl",
        strip_prefix = "boringssl-main-with-bazel",
        urls = [
            "https://github.com/google/boringssl/archive/refs/heads/main-with-bazel.zip",
            # "https://github.com/google/boringssl/archive/refs/heads/2272.zip",
        ],
    )
