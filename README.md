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

git_rev = "cbb181215ea981e64adf78ac8f389a7f32afa986"
http_archive(
    name = "rules_folly",
    sha256 = "0564a76755ee05f4f1b61aafa817bd1a8632daecdd4578ef39b2c37a1e739516",
    strip_prefix = "rules_folly-{}".format(git_rev),
    urls = [
        "https://github.com/storypku/rules_folly/archive/{}.tar.gz".format(git_rev),
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
