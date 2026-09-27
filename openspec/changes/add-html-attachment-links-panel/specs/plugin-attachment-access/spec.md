## ADDED Requirements

### Requirement: Current issue attachments are readable through Plugin API
Multica SHALL expose to an authenticated plugin with `issues:read` a read-only list of attachments belonging to the current issue, and each list item SHALL contain only `id`, `filename`, and `content_type`.

#### Scenario: Authorized plugin lists current issue attachments
- **WHEN** a plugin with `issues:read` requests attachments for its current issue context
- **THEN** Multica returns the attachments the current user may read with only `id`, `filename`, and `content_type`

#### Scenario: Plugin requests attachments outside its issue context
- **WHEN** a plugin surface requests attachments for an issue other than its current issue context
- **THEN** Multica rejects the request without revealing attachment metadata

#### Scenario: Plugin lacks issue read permission
- **WHEN** a plugin without `issues:read` requests issue attachments
- **THEN** Multica rejects the request without revealing attachment metadata

### Requirement: Attachment opens through the native preview
Multica SHALL let a plugin request opening an attachment from its current issue through the host, and the host SHALL validate issue membership and user access before opening the existing native attachment preview.

#### Scenario: Accessible attachment is opened
- **WHEN** the user activates a plugin link for an attachment belonging to the current issue
- **THEN** the host opens that original attachment in the existing native preview without copying or republishing it

#### Scenario: Attachment does not belong to current issue
- **WHEN** a plugin requests opening an attachment that does not belong to the current issue
- **THEN** the host refuses the request and does not navigate or disclose an attachment URL

### Requirement: Raw attachment locations remain private from the plugin
The attachment contract SHALL NOT expose storage keys, raw download URLs, signed URLs, creation dates, hashes, categories, or arbitrary metadata to plugin code.

#### Scenario: Plugin inspects attachment response
- **WHEN** a plugin receives the current issue attachment list
- **THEN** no storage location, URL, date, hash, category, or arbitrary metadata is present
