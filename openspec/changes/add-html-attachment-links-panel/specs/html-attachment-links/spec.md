## ADDED Requirements

### Requirement: Panel lists only HTML attachments
The plugin SHALL render in the native issue panel one link per current attachment whose normalized MIME type is `text/html` or whose filename ends in `.html` or `.htm` case-insensitively, and SHALL omit every other attachment.

#### Scenario: Issue has HTML and non-HTML attachments
- **WHEN** the panel loads an issue containing HTML and non-HTML attachments
- **THEN** the panel shows one link for each HTML attachment and no link for any non-HTML attachment

#### Scenario: Issue has no HTML attachments
- **WHEN** the panel loads an issue without an HTML attachment
- **THEN** the panel shows a compact empty state and no document links

#### Scenario: Attachment API fails
- **WHEN** the attachment list cannot be loaded
- **THEN** the panel shows a retryable error state without displaying stale document links

### Requirement: Links open the existing attachment
Each document entry SHALL be a keyboard-accessible link control that delegates activation to the host attachment-open command for that attachment id.

#### Scenario: User activates a document link
- **WHEN** the user activates a document link by pointer or keyboard
- **THEN** the plugin asks the host to open the corresponding original attachment in the native preview

### Requirement: User can set a short display title
The plugin SHALL let the user replace a link's filename with an issue-specific display title of at most 80 Unicode code points and SHALL store only the mapping from attachment id to trimmed title in workspace plugin storage.

#### Scenario: User saves a valid title
- **WHEN** the user saves a non-empty title within the length limit for an HTML attachment
- **THEN** the corresponding link displays the trimmed title after reload and still opens the same attachment id

#### Scenario: User clears a title
- **WHEN** the user clears the saved title for an HTML attachment
- **THEN** the plugin removes that override and displays the attachment filename

#### Scenario: User enters an invalid title
- **WHEN** the user attempts to save a title that is empty after trimming or exceeds 80 Unicode code points
- **THEN** the plugin does not save it and presents an inline validation message

### Requirement: Attachment API remains the source of truth
The plugin SHALL derive every displayed document from the current attachment API response and SHALL ignore stored title entries whose ids are absent from that response or no longer classify as HTML.

#### Scenario: Titled attachment is removed
- **WHEN** a previously titled attachment is absent from the current attachment response
- **THEN** the plugin does not display a link for that stored attachment id

### Requirement: Panel exposes no document catalog metadata
The panel SHALL display only each document link title and the controls required to edit that title, and SHALL NOT display hashes, dates, categories, status, filters, or registry information.

#### Scenario: Panel renders an HTML attachment
- **WHEN** the panel renders a document entry
- **THEN** its steady state contains the link title without hash, date, category, status, filter, or registry metadata
