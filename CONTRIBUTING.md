# Contributing to multica-plugins

## Setup

```sh
git clone https://github.com/maximchikAlexandr/multica-plugins.git
cd multica-plugins
git config core.hooksPath .githooks
```

## Workflow

1. Create a feature branch from `main`.
2. Add or update the relevant OpenSpec change for behavioral work.
3. Keep each plugin self-contained under `plugins/<plugin-key>/`.
4. Run `make check`.
5. Use Conventional Commits and open a pull request against `main`.

Never commit secrets or private service URLs. Report vulnerabilities according to [SECURITY.md](SECURITY.md).

By contributing, you agree that your contributions are licensed under the [MIT License](LICENSE).

