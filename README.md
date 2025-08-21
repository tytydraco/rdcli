# Rdcli

Real-Debrid CLI.

# Usage

```
-h, --[no-]help              Shows program usage.
-k, --api-key (mandatory)    Real-Debrid API key.
-o, --output-directory       Output directory.
                             (defaults to ".")
```

Specify magnet URLs as arguments, for example:

`rdcli -k <KEY> -- link1 link2 link3`

# Mechanism

Rdcli uses the exposed API from Real-Debrid to add a magnet,
download it, unrestrict the URL, and download it locally.