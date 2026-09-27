# Repository instructions

## Structure

- Keep every plugin self-contained under `plugins/<plugin-key>/`.
- Keep shared infrastructure at the repository root only when at least two plugins use it.
- Use OpenSpec for proposed features and behavior changes.
- Never commit secrets, credentials, private webhook URLs, or internal report links.

## Commits

All commits must follow Conventional Commits:

```text
<type>[optional scope]: <description>
```

Allowed types: `feat`, `fix`, `docs`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `style`, `revert`.

The repository enforces this through `.githooks/commit-msg`. Enable the hook with:

```sh
git config core.hooksPath .githooks
```

