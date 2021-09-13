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

In your `WORKSPACE` file, add the following:

```
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_folly",
    sha256 = "d9e6d0874eea008840c20331e8df4e89d2bd2d4d4452688b1ef06a621f91f6d1",
    strip_prefix = "rules_folly-0.1.0",
    urls = [
        "https://github.com/storypku/rules_folly/archive/v0.1.0.tar.gz",
    ],
)

load("//bazel:folly_deps.bzl", "folly_deps")

folly_deps()

load("@com_github_nelhage_rules_boost//:boost/boost.bzl", "boost_deps")

boost_deps()
```

Then you can add Folly in the `deps` section of target rule in the `BUILD` file:

```
  deps = [
      # ...
      "@folly//:folly",
      # ...
  ],
```

## ROADMAP
1. Make it work for latest Folly
2. Make it configurable, e.g., whether openssl/boringssl should be used, if glog was with gflags support, etc.
