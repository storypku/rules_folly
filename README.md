# `rules_folly` -- Bazel Build Rules for Folly

## Pre-requisites

On Ubuntu,

```bash
sudo apt-get update \
    && sudo apt-get -y install --no-install-recommends \
    autoconf \
    automake \
    libtool \
    libssl-dev
```

## How To Use

1. In your `WORKSPACE` file, add the following:

```
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "com_github_storypku_rules_folly",
    sha256 = "16441df2d454a6d7ef4da38d4e5fada9913d1f9a3b2015b9fe792081082d2a65",
    strip_prefix = "rules_folly-0.2.0",
    urls = [
        "https://github.com/storypku/rules_folly/archive/v0.2.0.tar.gz",
    ],
)

load("@com_github_storypku_rules_folly//bazel:folly_deps.bzl", "folly_deps")
folly_deps()

load("@com_github_nelhage_rules_boost//:boost/boost.bzl", "boost_deps")
boost_deps()
```

If you would like to use Folly without gflags, you should change the line
`folly_deps()` to:

```
folly_deps(with_gflags = 0)
```

2. Then you can add Folly in the `deps` section of target rule in the `BUILD` file:

```
  deps = [
      # ...
      "@folly//:folly",
      # ...
  ],
```

## ROADMAP
1. (Done) Make it work for recent versions of Folly
2. (Done) Make rules_folly configurable, e.g., whether openssl/boringssl should be used,
    if glog was with gflags support, etc.
