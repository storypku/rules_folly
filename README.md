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
    name = "com_github_zhuangAnjun_rules_folly",
    strip_prefix = "rules_folly-1.0",
    urls = [
        "https://github.com/zhuangAnjun/rules_folly/archive/refs/tags/1.0.tar.gz",
    ],
)

load("@com_github_zhuangAnjun_rules_folly//bazel:folly_deps.bzl", "folly_deps")
folly_deps()

load("@com_github_nelhage_rules_boost//:boost/boost.bzl", "boost_deps")
boost_deps()
```

If you would like to use Folly without gflags, instead you should change the line
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

## CHANGELOG
2020.11.24 Support boringssl and folly verison 2022.11.14.00
