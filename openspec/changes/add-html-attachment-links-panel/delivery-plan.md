## Delivery contract

- Task key: `MYL-329`
- OpenSpec change: `add-html-attachment-links-panel`
- Delivery mode: `single_wp_no_dag`
- Authoritative sizing: issue properties `Estimate min, hours`, `Estimate, hours`, and `Estimate max, hours`
- Confidence: medium. The existing attachment query and native preview materially reduce implementation work, while the cross-repository platform/SDK integration and web/desktop surface verification widen uncertainty.

The authoritative `Estimate, hours` property is within the single-package topology threshold. Therefore the implementation SHALL be delivered as exactly one all-covering work package. Operational assignment and progress SHALL remain in Multica issues rather than these planning artifacts.

## Estimate evidence and assumptions

- Current Plugin SDK has issue, comments, storage, hooks, and resize methods but no attachment contract.
- Current surface bridge allowlist has no attachment path and the plugin iframe cannot safely navigate the host application itself.
- Current Public API issue and comment DTOs exclude attachments.
- The main application already provides authorized issue attachment queries, HTML classification, native preview routing, and web/desktop navigation primitives that SHALL be reused.
- The estimate assumes one developer familiar with TypeScript/React and Go, the current upstream Multica main implementation, no third-party dependencies, and no schema migration.
- The estimate includes focused platform/API/bridge tests, plugin unit and surface tests, manual web/desktop verification, documentation, and review rework allowance.
- The estimate excludes unrelated platform refactors, a general metadata system, a new viewer, deployment queue time, and external approval latency.

## Authoritative repositories and publication

| Responsibility | Canonical repository | Pinned base | Feature branch | Publication contract |
|---|---|---|---|---|
| Platform API, SDK, surface bridge and host navigation | `https://github.com/multica-ai/multica.git` | `fa5d470ae40a082d952b50e843287906566785a6` from `main` | `feat/myl-329-plugin-attachment-access` | Ordinary push to the canonical remote; PR targets canonical `main`. A fork or local-only patch is not an accepted substitute. |
| Plugin, OpenSpec and plugin tests/docs | `https://github.com/maximchikAlexandr/multica-plugins` | `6b777a00d42c42c294240d5597a7602f35a2fa01` from `main` | `feat/myl-329-html-attachment-links` | Ordinary push to the canonical remote; PR targets canonical `main`. |

The Manager SHALL provide two clean worktrees at these exact bases to the same WP assignee. If either base is unavailable or direct ordinary push to either canonical feature branch is unauthorized, the WP is blocked and SHALL return for planning revision rather than changing repository, base, branch, or publication destination.

The implementation handoff SHALL identify `core_result_sha` and `plugin_result_sha`, prove each pinned base is an ancestor of its result, prove each canonical remote feature branch equals its result, and record clean state for both worktrees. The core branch SHALL be published first. The plugin branch and integration evidence SHALL be published second. Plugin activation SHALL wait for a compatible platform/SDK revision.

## Work package

### WP-MYL-329-01 — Native HTML attachment links

**Task coverage:** `1.1`, `1.2`, `1.3`, `2.1`, `2.2`, `2.3`, `2.4`, `2.5`, `3.1`, `3.2`. Each OpenSpec task is covered exactly once.

**Deliverable:** a backward-compatible minimal Multica attachment contract and a self-contained `html-attachment-links` issue-panel plugin that lists current HTML attachments, opens each original file through the native preview, and persists only optional short display-title overrides.

**Owned responsibility scope:**

- In `https://github.com/multica-ai/multica.git`: Public/Plugin API issue attachment route, response type, access control, route registration, SDK method, surface bridge allowlist, host open command, native preview/navigation adapter, and directly related platform tests.
- In `https://github.com/maximchikAlexandr/multica-plugins`: `plugins/html-attachment-links/` manifest, surface bundle/source, styling, title storage adapter, tests, fixtures, documentation, OpenSpec, and repository integration files directly required by the plugin.
- No unrelated Multica core behavior, attachment schema, shared plugin framework, or other plugin directory.

**Critical shared files:** in the core repository, Public API route/type files, `packages/plugin-sdk/index.ts`, `packages/views/plugins/surface-bridge.ts`, and the host component that constructs the bridge with issue context and navigation; in the plugin repository, root validation/configuration files touched to register or build `plugins/html-attachment-links/`. The implementer SHALL preserve unrelated concurrent edits and keep changes to the named attachment contract.

**Contract surface:**

- `GET /v1/issues/{issue_ref}/attachments` under existing `issues:read`, returning only `id`, `filename`, and `content_type` for the current readable issue.
- `multica.issue.attachments()` with the same minimal response.
- `multica.ui.openAttachment(attachmentId)`, scoped to current issue context and delegated to the existing native preview after host-side validation.
- issue-scoped workspace storage containing only `attachment_id -> title` overrides; attachment API remains the source of displayed documents.

**Definition of done and evidence:**

- All requirements and scenarios in both delta specs have automated coverage at the lowest useful layer.
- Cross-issue, unauthorized, and invalid attachment-open requests fail without leaking an attachment URL or metadata.
- Web and desktop checks show only HTML attachments, correct empty/error/retry behavior, keyboard activation, filename fallback, persisted/cleared titles, and native preview of the original attachment.
- Plugin manifest declares only `issues:read` and `storage:workspace`; no network scope, third-party runtime dependency, secret, internal URL, document copy, or general metadata facility is present.
- Platform tests, plugin tests/build, manifest validation, strict OpenSpec validation, and repository checks pass with commands and exit codes recorded in the implementation handoff.
- Both canonical feature branches equal their declared exact result SHAs, both results descend from the pinned bases, both worktrees are clean, and the plugin is verified against the result of the platform contract.

**Parallel-safety rationale:** platform endpoint, SDK, bridge, plugin UI, two-repository publication, and final integration form one small cross-repository contract. Splitting ownership would create a shared-contract coordination boundary without a qualifying independent execution front; one implementer/verifier pair owns both repositories and the complete vertical slice.
