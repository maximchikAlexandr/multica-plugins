## 1. Minimal platform contract

- [ ] 1.1 Add the authorized current-issue attachment list to Public/Plugin API with only `id`, `filename`, and `content_type`, reusing `issues:read` and existing issue access checks.
- [ ] 1.2 Extend the surface bridge allowlist and Plugin SDK with `issue.attachments()` and contract tests for allowed, cross-issue, and unauthorized requests.
- [ ] 1.3 Add the scoped `ui.openAttachment(attachmentId)` host command, reuse the native preview/navigation flow, and test membership validation plus rejection without URL disclosure.

## 2. Self-contained plugin

- [ ] 2.1 Create `plugins/html-attachment-links/` with a manifest that declares the issue panel surface and only `issues:read` plus `storage:workspace`.
- [ ] 2.2 Implement loading, exact HTML classification, compact loading/empty/error states, and retry without stale links.
- [ ] 2.3 Render keyboard-accessible link controls that invoke the host open command and preserve native web/desktop behavior.
- [ ] 2.4 Implement issue-scoped `attachment_id -> title` storage, filename fallback, Unicode length validation, clearing, and ignored stale entries.
- [ ] 2.5 Add focused unit and surface integration tests for classification, rendering, title persistence, invalid input, stale mappings, retry, and attachment activation.

## 3. Verification and documentation

- [ ] 3.1 Document installation, required capabilities, privacy boundaries, and manual verification for web and desktop without internal URLs or secrets.
- [ ] 3.2 Run platform contract tests, plugin tests/build, manifest validation, and repository OpenSpec checks; publish both canonical feature branches and record both exact result SHAs, base ancestry, remote equality, clean worktrees, and integration evidence in the implementation handoff.
