load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def folly_deps():
    maybe(
        http_archive,
        name = "com_github_gflags_gflags",
        sha256 = "34af2f15cf7367513b352bdcd2493ab14ce43692d2dcd9dfc499492966c64dcf",
        strip_prefix = "gflags-2.2.2",
        urls = [
            "https://apollo-system.cdn.bcebos.com/archive/6.0/v2.2.2.tar.gz",
            "https://github.com/gflags/gflags/archive/v2.2.2.tar.gz",
        ],
    )
    maybe(
        http_archive,
        name = "com_github_google_glog",
        sha256 = "f28359aeba12f30d73d9e4711ef356dc842886968112162bc73002645139c39c",
        strip_prefix = "glog-0.4.0",
        urls = [
            "https://apollo-system.cdn.bcebos.com/archive/6.0/v0.4.0.tar.gz",
            "https://github.com/google/glog/archive/v0.4.0.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "double-conversion",
        strip_prefix = "double-conversion-3.1.5",
        sha256 = "a63ecb93182134ba4293fd5f22d6e08ca417caafa244afaa751cbfddf6415b13",
        urls = ["https://github.com/google/double-conversion/archive/v3.1.5.tar.gz"],
    )

    # ===== libevent (libevent.org) dependency =====
    maybe(
        http_archive,
        name = "com_github_libevent_libevent",
        sha256 = "316ddb401745ac5d222d7c529ef1eada12f58f6376a66c1118eee803cb70f83d",
        urls = ["https://github.com/libevent/libevent/archive/release-2.1.8-stable.tar.gz"],
        strip_prefix = "libevent-release-2.1.8-stable",
        build_file = "@//third_party/libevent:libevent.BUILD",
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

    maybe(
        http_archive,
        name = "com_github_google_snappy",
        build_file = "@//third_party/snappy:snappy.BUILD",
        strip_prefix = "snappy-1.1.9",
        sha256 = "75c1fbb3d618dd3a0483bff0e26d0a92b495bbe5059c8b4f1c962b478b6e06e7",
        urls = [
            "https://github.com/google/snappy/archive/1.1.9.tar.gz",
        ],
    )
    maybe(
        native.new_local_repository,
        name = "openssl",
        path = "/usr/include",
        build_file = "@//third_party/openssl:openssl.BUILD",
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
    folly_version = "2019.11.11.00"
    http_archive(
        name = "folly",
        build_file = "@rules_folly//third_party/folly:folly.BUILD",
        sha256 = "3b050f4ea17a12d7675ec4f1b02ef33dea2a5d46f09cc68e0165ca5b352c34b4",
        strip_prefix = "folly-{}".format(folly_version),
        urls = [
            "https://github.com/facebook/folly/archive/v{}.tar.gz".format(folly_version),
        ],
    )
