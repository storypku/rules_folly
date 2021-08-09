# `rules_folly` -- Bazel Build Rules for Folly

## Pre-requisites

On Ubuntu,

```bash
sudo apt-get update \
    && sudo apt-get -y install --no-install-recommends \
    autoconf \
    automake \
    libtool \
    libdouble-conversion-dev \
    libssl-dev
    # libsnappy-dev
```

## How To Use

In your `WORKSPACE` file, add the following:

```
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_folly",
    sha256 = "dd5eb2822184c17f0666dde3b0e638b4dcb4042699389449db01181f4e6853d7",
    strip_prefix = "rules_folly-0.0.2",
    urls = [
        "https://github.com/storypku/rules_folly/archive/v0.0.2.tar.gz",
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
