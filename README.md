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
    sha256 = "d213d3321faf8322e901f404f889c4ed4d0d17ebe456a081ede68e7c3433ab43",
    strip_prefix = "rules_folly-0.1.1",
    urls = [
        "https://github.com/storypku/rules_folly/archive/v0.1.1.tar.gz",
    ],
)

load("@com_github_storypku_rules_folly//bazel:folly_deps.bzl", "folly_deps")
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
