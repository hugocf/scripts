# Unix Info

*(more recent on top; mainly `bash`)*

[TOC]

## Check and make sure a script is sourced

- [Example link](http://example.com)

```shell
# Exit if this script was not sourced as an import
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    >&2 echo "Error: Must run as an import source"    # stderr
    >&2 echo "Try: source \"${BASH_SOURCE[0]}\""      # stderr
    exit
fi
```


