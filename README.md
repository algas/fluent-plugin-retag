# fluent-plugin-retag, a plugin for [Fluentd](http://fluentd.org)

## Overview

Output plugin only retagging.

* simple retag
* remove tag prefix
* add tag prefix

## Configuration

### Simple Configuration

To retag foo.bar to hoge.fuga:

    <match foo.bar>
      type retag
      tag hoge.fuga
    </match>

To retag foo.bar.** to xyz.bar.**:

    <match foo.bar>
      type retag
      remove_prefix foo
      add_prefix xyz
    </match>

### Useful Configuration

If you want to use branch condition, it is useful to use out_copy with fluent-plugin-retag.

    <match foo.bar.**>
      type copy
      <store>
        type retag
        add_prefix copied
      </store>
      <store>
        ...
      </store>
    </match>

    <match copied.foo.bar.**>
      ...
    </match>

## Copyright

* Copyright (c) 2013- Masahiro Yamauchi
* License
  * Apache License, Version 2.0

