# multica-plugins

Plugins that extend Multica for this workspace.

## Structure

Each plugin lives in its own directory:

```text
plugins/
  <plugin-key>/
    multica.plugin.json
```

Plugin-specific source, tests, and documentation stay inside that plugin's directory. Shared tooling belongs at the repository root only after more than one plugin needs it.

## Development

```sh
git config core.hooksPath .githooks
make check
```

Feature and behavior changes are designed through [OpenSpec](https://github.com/Fission-AI/OpenSpec). See [CONTRIBUTING.md](CONTRIBUTING.md) for the contribution workflow.

## License

[MIT](LICENSE)

