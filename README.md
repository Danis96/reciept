# Refyn

Refyn is a Flutter receipt tracker focused on fast capture, local-first storage, AI-assisted receipt parsing, and lightweight personal budget visibility.

The app lets you:

- scan receipts from camera or gallery
- parse receipt data with Gemma via Google Generative Language API
- review and edit parsed data before saving
- store receipts locally with line items and original image references
- browse receipt history
- see dashboard summaries and category budget progress
- export receipts as CSV, JSON, or PDF
- create email drafts with receipt reports
- export, import, and clear local backups
- switch theme and app language

## Current Product Shape

Main tabs:

- `Home` for monthly summary, quick actions, recent receipts, and budget progress
- `Scan` for image upload/capture, AI parsing, review, and save flow
- `History` for stored receipts
- `Settings` for theme, language, AI config, export, backup, legal, and about

Navigation:

- root route: dashboard shell with bottom tabs
- details route: receipt details page with export, edit, and delete actions

Platforms:

- Flutter mobile app
- Android and iOS project files present

## Tech Stack

- Flutter
- Dart `^3.10.8`
- `provider` for app state
- `drift` + `drift_flutter` for local database
- `intl` for localization and formatting
- `image_picker` for camera/gallery
- `flutter_image_compress` for upload optimization
- `flutter_dotenv` for local environment config
- `share_plus`, `flutter_email_sender`, `file_picker`, `pdf`, `archive`

## Architecture

Project follows one-way flow described in [ARCHITECTURE.md](./ARCHITECTURE.md):

`Repository -> Controller -> ActionUtils -> UI`

Layer intent:

- `repository/`: data access, mapping, persistence, external calls
- `controllers/`: `ChangeNotifier` state holders for each feature
- `action_utils/`: dialogs, snackbars, navigation, multi-step user actions
- `ui/`: pages and widgets only

Boot wiring lives in [lib/app/app_root.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/lib/app/app_root.dart), where providers, repositories, database, AI config, and controllers are composed.

## Project Structure

```text
lib/
  app/
    app_root.dart
    my_app.dart
    features/
      ai/
      budgets/
      dashboard/
      export/
      history/
      receipt_details/
      scan/
      settings/
    helpers/
    models/
    widgets/
  database/
    app_database.dart
```

Important entry points:

- [lib/main.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/lib/main.dart) boots Flutter, locks portrait orientation, loads `.env`
- [lib/app/my_app.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/lib/app/my_app.dart) configures `MaterialApp`, themes, locale, and delegates
- [lib/routing/app_router.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/lib/routing/app_router.dart) defines root and receipt details routes
- [lib/database/app_database.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/lib/database/app_database.dart) defines Drift schema and migrations

## Core Features

### 1. AI Receipt Scanning

Scan flow:

- pick image from gallery or camera
- compress and prepare image bytes
- send prompt + image to Gemma `generateContent`
- sanitize and parse structured JSON response
- map payload into app receipt model
- let user review/edit result
- save validated receipt locally

Main files:

- [lib/app/features/scan/repository/gemma_receipt_scan_service.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/lib/app/features/scan/repository/gemma_receipt_scan_service.dart)
- [lib/app/features/scan/repository/scan_repository.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/lib/app/features/scan/repository/scan_repository.dart)
- [lib/app/features/scan/repository/gemma_receipt_mapper.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/lib/app/features/scan/repository/gemma_receipt_mapper.dart)
- [lib/app/features/scan/repository/receipt_ai_parser.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/lib/app/features/scan/repository/receipt_ai_parser.dart)
- [lib/app/features/scan/repository/receipt_ai_prompt_builder.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/lib/app/features/scan/repository/receipt_ai_prompt_builder.dart)

Built-in failure handling includes:

- missing API key
- file not found / empty image
- low-quality image rejection
- non-receipt rejection
- invalid JSON envelope or structured payload
- model id mismatch / API error / timeout

### 2. Local Receipt Storage

Receipts are stored locally with Drift.

Tables:

- `receipts`
- `receipt_items`
- `category_budgets`
- `app_settings`

Stored receipt shape includes:

- merchant info
- fiscal metadata
- payment info
- totals
- category
- confidence
- raw JSON/text
- image path
- line items
- creation timestamp

Schema version:

- current Drift schema version is `4`

### 3. Dashboard and Budgets

Dashboard summarizes:

- total receipts
- this month receipt count
- this month spending
- total budget
- remaining budget
- top spending category
- per-category budget progress
- recent receipts

Budget logic lives mainly in:

- [lib/app/features/budgets/repository/category_budget_repository.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/lib/app/features/budgets/repository/category_budget_repository.dart)
- [lib/app/features/budgets/repository/monthly_budget_sync_repository.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/lib/app/features/budgets/repository/monthly_budget_sync_repository.dart)
- [lib/app/features/budgets/repository/category_budget_catalog.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/lib/app/features/budgets/repository/category_budget_catalog.dart)

### 4. Export and Backup

Supported receipt exports:

- `CSV`
- `JSON`
- `PDF`
- email draft with generated summary

Local backup supports:

- receipts
- receipt images when files still exist
- category budgets
- app settings

Main files:

- [lib/app/features/export/repository/receipt_export_service.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/lib/app/features/export/repository/receipt_export_service.dart)
- [lib/app/features/export/utils/receipt_pdf_builder.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/lib/app/features/export/utils/receipt_pdf_builder.dart)
- [lib/app/features/export/utils/receipt_report_email_builder.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/lib/app/features/export/utils/receipt_report_email_builder.dart)
- [lib/app/features/settings/application/local_backup_service.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/lib/app/features/settings/application/local_backup_service.dart)

### 5. Settings and Personalization

Settings currently cover:

- theme mode
- language
- AI API key
- AI model selection
- AI thinking level
- receipt export
- backup import/export
- local data clearing

## Localization

Current supported locales:

- English `en`
- Bosnian `bs`
- Danish `da`

Localization is hand-rolled, not generated from ARB files.

Source:

- [lib/l10n/app_localizations.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/lib/l10n/app_localizations.dart)

Notes:

- app locale is persisted in `app_settings`
- `Intl.defaultLocale` is set from selected app locale
- some screens still contain hardcoded English strings and are not fully localized yet

## Environment Configuration

Refyn supports local `.env` and compile-time `--dart-define` fallbacks.

Environment keys:

- `GEMMA_API_KEY`
- `GEMMA_MODEL`
- `GEMMA_API_BASE_URL`

Example:

```env
GEMMA_API_KEY=your_gemma_api_key_here
GEMMA_MODEL=gemma-4-26b-a4b-it
GEMMA_API_BASE_URL=https://generativelanguage.googleapis.com/v1beta
```

Use the included `.env.example` as the template:

```bash
cp .env.example .env
```

Security notes:

- `.env` is gitignored
- do not commit real API keys
- app can also read values from `--dart-define` if `.env` is missing

## Getting Started

### Prerequisites

- Flutter SDK installed
- Dart SDK matching Flutter toolchain
- Android Studio or Xcode for device builds
- valid Google Generative Language / Gemma API key for scan feature

### Install

```bash
flutter pub get
cp .env.example .env
```

Fill in `.env`, then run:

```bash
flutter run
```

Alternative with dart defines:

```bash
flutter run \
  --dart-define=GEMMA_API_KEY=your_key \
  --dart-define=GEMMA_MODEL=gemma-4-26b-a4b-it \
  --dart-define=GEMMA_API_BASE_URL=https://generativelanguage.googleapis.com/v1beta
```

## Useful Commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run
flutter build apk --debug
flutter build web --release
dart run build_runner build
```

## Platform Permissions

iOS permissions declared in [ios/Runner/Info.plist](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/ios/Runner/Info.plist):

- camera usage
- photo library read
- photo library add

Android manifest currently defines app metadata and activity config in [android/app/src/main/AndroidManifest.xml](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/android/app/src/main/AndroidManifest.xml).

## Testing

Current test coverage includes:

- widget smoke test for main tabs
- receipt mapper behavior
- receipt AI parser normalization and validation
- category alias normalization

Test files:

- [test/widget_test.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/test/widget_test.dart)
- [test/gemma_receipt_mapper_test.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/test/gemma_receipt_mapper_test.dart)
- [test/receipt_ai_parser_test.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/test/receipt_ai_parser_test.dart)
- [test/category_budget_catalog_test.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/test/category_budget_catalog_test.dart)

Run:

```bash
flutter test
```

## Known Gaps

- localization is partial; several screens still have hardcoded English strings
- README and architecture say `Controller`, while project rules in `ARCHITECTURE.md` still say `Provider`; codebase currently uses `ChangeNotifier` controllers
- app is portrait-locked in [lib/main.dart](/Users/danispreldzic/Desktop/Danis/PROJECTS/reciept/lib/main.dart)
- UI and strings still contain some legacy receipt-scanner naming in spots
- AI scan depends on network access and external API availability

## Design Notes

- splash uses `assets/splash.png` for both light and dark
- theme and visuals live under `theme/` plus feature-local UI utilities
- home and scan flows are the most product-forward surfaces

```bash
flutter analyze
flutter test
```
