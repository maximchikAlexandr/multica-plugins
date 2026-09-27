## Context

Актуальный Plugin SDK предоставляет контекст задачи, чтение самой задачи и комментариев, storage и UI resize, но не раскрывает вложения. Public API DTO задачи и комментария также не содержат attachments, а allowlist surface bridge не пропускает attachment route. При этом основное приложение уже имеет авторизованный issue attachment endpoint и штатную HTML preview page с sandboxed iframe.

Plugin surface выполняется на выделенном origin во вложенном sandboxed iframe. Поэтому относительная ссылка указывает не на приложение Multica, выдача raw или временного download URL ухудшает безопасность и долговечность, а расширение sandbox ради pop-up избыточно.

Проверенный platform baseline — canonical repository `https://github.com/multica-ai/multica.git`, ветка `main`, revision `fa5d470ae40a082d952b50e843287906566785a6`. Plugin baseline — canonical repository `https://github.com/maximchikAlexandr/multica-plugins`, ветка `main`, revision `6b777a00d42c42c294240d5597a7602f35a2fa01`. Эти две revisions образуют единый исходный снимок design.

## Goals / Non-Goals

**Goals:**

- показать HTML-вложения текущей задачи в компактном issue panel;
- открыть исходное вложение в существующем штатном preview, не копируя и не публикуя его повторно;
- дать пользователю короткий локальный отображаемый заголовок;
- закрыть доказанный Plugin API gap минимальным нативным контрактом.

**Non-Goals:**

- SHA, даты, категории, полнотекстовый поиск, фильтры и сортировки;
- индекс, каталог или внешний реестр документов;
- отдельная платформа метаданных вложений;
- просмотр сторонних URL, создание копий или новая HTML viewer implementation;
- изменение общей attachment model или выдача storage/download URL plugin-коду.

## Decisions

### 1. Узкий attachment contract вместо расширения issue DTO

Public/Plugin API получает `GET /v1/issues/{issue_ref}/attachments`, защищённый существующим `issues:read`. Ответ содержит только `id`, `filename` и `content_type` для вложений задачи, которые текущий пользователь уже вправе читать. Surface bridge разрешает только этот новый read route, а SDK предоставляет `multica.issue.attachments()`.

Это сохраняет attachment concern явным и не утяжеляет каждый `issue.get()`. Новый scope не вводится: право читать задачу уже является необходимым условием чтения её вложений.

Рассмотренная альтернатива — извлекать вложения из комментариев — отклонена: текущие public comment DTO их не содержат и такой путь пропускает вложения самой задачи.

### 2. Открытие через host-команду штатного preview

SDK получает `multica.ui.openAttachment(attachmentId)`. Surface bridge принимает команду только для текущего issue context, повторно проверяет доступность attachment в этой задаче и передаёт открытие штатной preview route приложению. Plugin отображает элемент `<a>` и перехватывает его активацию мышью или клавиатурой для вызова host-команды; iframe самостоятельно не навигируется.

Это переиспользует существующие web/desktop navigation и sandboxed HTML preview. Альтернативы с raw URL, подписанным URL, ослаблением iframe sandbox или новым viewer отклонены как менее безопасные и более сложные.

### 3. HTML определяется существующими признаками

Plugin считает вложение HTML, когда нормализованный `content_type` равен `text/html` либо имя файла оканчивается на `.html` или `.htm` без учёта регистра. Это совпадает с действующей логикой preview и покрывает вложения с неполным MIME type.

### 4. Заголовки — только минимальное соответствие в plugin storage

Plugin хранит под одним issue-scoped ключом workspace storage JSON object вида `{ "<attachment-id>": "<title>" }`. Ключ включает issue id. Значение после trim должно быть непустым и не длиннее 80 Unicode code points. При отсутствии записи ссылка показывает `filename`; удаление текста удаляет override и возвращает fallback.

При каждом отображении источником списка остаётся attachment API. Записи для отсутствующих или не-HTML attachments игнорируются, поэтому storage не становится реестром документов. Отдельные model, backend table и metadata API не создаются.

### 5. Самодостаточный plugin без общей инфраструктуры

Manifest запрашивает только `issues:read` и `storage:workspace`. Surface bundle, стили, тесты и документация находятся в `plugins/html-attachment-links/`. Сетевой scope и сторонние runtime dependencies отсутствуют; сборка использует репозиторные plugin conventions.

### 6. Два репозитория публикуются как один вертикальный результат

Platform часть создаётся от pinned Multica revision в ветке `feat/myl-329-plugin-attachment-access` и публикуется обычным push непосредственно в canonical remote `https://github.com/multica-ai/multica.git` для PR в `main`. Plugin и OpenSpec продолжаются от pinned plugin revision в ветке `feat/myl-329-html-attachment-links` и публикуются обычным push в canonical remote `https://github.com/maximchikAlexandr/multica-plugins` для PR в `main`.

Один Implementer/WP Verifier pair владеет обеими worktrees и обеими ветками. Handoff считается полным только при наличии двух exact result SHA, доказательства ancestry от соответствующих pinned bases, clean worktrees, совпадения каждого remote branch с его result SHA и интеграционной проверки plugin против изменённого platform contract. Подмена canonical core publication fork-веткой или неприкреплённым локальным patch запрещена; отсутствие права обычного push блокирует WP и требует planning revision.

Platform branch публикуется первой, plugin branch — второй. Активация plugin в среде разрешена только после доступности совместимой platform/SDK revision; это release ordering внутри одного WP, а не отдельный work package.

## Risks / Trade-offs

- **[Изменение пересекает два canonical repositories]** → обе pinned bases, feature-ветки, publication remotes, ownership и двух-SHA acceptance закреплены в design и delivery plan; один исполнитель отвечает за интеграцию.
- **[У вложения неверны и MIME type, и расширение]** → оно не показывается; это безопаснее эвристического чтения содержимого.
- **[Сохранённый заголовок остаётся после удаления вложения]** → запись не отображается и может быть удалена при следующем успешном сохранении карты; отдельная очистка и registry не нужны.
- **[Параллельное редактирование title в двух вкладках использует last-write-wins]** → приемлемо для необязательного display-only значения; транзакционный metadata service не вводится.
- **[Host-команда не является обычной навигацией iframe]** → элемент остаётся доступным с клавиатуры и визуально является ссылкой, а документ открывается тем же native flow, что и в основном UI.

## Migration Plan

1. Опубликовать и принять backward-compatible platform contract и Plugin SDK из canonical Multica feature-ветки.
2. Опубликовать plugin feature-ветку и собрать plugin против принятого SDK contract.
3. Установить plugin и проверить web и desktop issue panel на существующих HTML и non-HTML attachments.
4. Для rollback отключить plugin; platform additions остаются совместимыми и могут быть удалены отдельным откатом, поскольку данных кроме plugin storage не создаётся.

## Open Questions

Нет. Контракт, фильтрация, хранение и поведение открытия определены этим design и specs.
