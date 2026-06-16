# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

`rose_hr` is a Flutter (Dart SDK ^3.8.1) HR mobile app for employees and managers — attendance punching, shift summaries, permission/holiday/work-mission requests, punch corrections, and manager approvals. Targets Android (`com.roseholding.crm`) and iOS. UI supports English and Arabic (RTL); the default locale is Arabic.

## Commands

```bash
flutter pub get                       # install deps
flutter run                           # run on connected device/emulator
flutter run --dart-define-from-file=.env.prod   # run with prod env (CI uses this)

# Codegen — REQUIRED after editing any *_model.dart (json_serializable),
# env.dart (envied), or assets. Generated files: *.g.dart, env.g.dart.
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch --delete-conflicting-outputs

flutter analyze                       # lint (very_good_analysis ruleset)
flutter test                          # run all tests
flutter test test/path_to_test.dart  # run a single test file
flutter test --name "description"     # run tests matching a name

flutter gen-l10n                      # regenerate localizations from lib/l10n/*.arb
```

### Scaffolding a feature (Mason)

New features are generated from the `feature` brick, which creates the data + presentation skeleton:

```bash
mason make feature   # prompts for the feature name; writes lib/features/<name>/...
```

## Architecture

Clean-architecture-lite, organized by feature under `lib/features/<feature>/`. Each feature has:

- `data/datasources/` — talk to the API via `ApiConsumer`, return raw `*Model` objects.
- `data/models/` — `json_serializable` request/response models (`fromJson`/`toJson`, `.g.dart`).
- `data/repositories/` — wrap datasource calls in try/catch, map exceptions to `Failure`s, return `Result<T>`.
- `presentation/cubit/` (or `bloc/`) — `flutter_bloc` state holders.
- `presentation/screens/` and `presentation/widgets/` — UI.

Most features use the data + presentation split above. The `stores` feature additionally has a full `domain/` layer (entities, repositories, usecases) — it's the exception, not the norm; follow the simpler pattern of the other features unless extending `stores`.

### Shared infrastructure (`lib/common/`)

- **Dependency injection** — `get_it` via `injection_container.dart`. `init()` (called in `main`) registers datasources/repositories as lazy singletons and cubits/blocs as factories. Resolve with `sl<T>()`. When adding a feature, register its datasource → repository → bloc here.
- **Networking** — `ApiConsumer` (abstract) implemented by `DioConsumer`. `AppIntercepters` injects `Authorization: Bearer <apiKey>`, content-type, and a `lang` header (`en_US`/`ar_001`). Errors are thrown as typed `ServerException` subclasses (`networking/`, `error/exceptions.dart`) and mapped by repositories to `Failure`s (`error/failures.dart`). Note: in debug mode `DioConsumer` bypasses TLS certificate validation; release mode validates normally.
- **Result type** — `sealed class Result<T>` with `Success<T>` / `Error<T>` (`networking/result.dart`). Repositories return this; UI/cubits switch on it.
- **Routing** — `go_router` in `routing/app_router.dart`; route names/paths in `app_routes.dart`. Some routes pass objects via `state.extra` (e.g. an existing cubit or a model). `RoutingNotifier` drives `refreshListenable` for auth-based redirects.
- **Local storage** — `AppManager` singleton wraps `shared_preferences` (init'd in `main` with `AppManager.init(sl())`). Keys live in `constants/app_strings.dart` (uid, email, name, apiKey, lang, etc.). Auth state = presence of `apiKey`.
- **Theming** — custom `ThemeExtension`s in `lib/theme/` (`AppColors`, `AppTypography`, input/button themes) wired into `MaterialApp` light & dark themes. `ThemeScopeWidget` manages theme mode + locale; access theme via `context` extensions in `theme_ext.dart`. Uses `flutter_screenutil` with a 375×812 design size — size UI with `.w`/`.h`/`.sp`/`.r`.
- **Notifications** — Firebase Cloud Messaging + `flutter_local_notifications`. `NotificationService` initializes in `main`; `firebaseBackgroundHandler` handles background messages. FCM device token is registered with the backend on login (`AuthDataSource.registerFcmToken`).
- **Location & timezone** — `LocationProvider` (geolocator) requests permission in `main`. `TimezoneManager` auto-detects Egypt vs. Saudi Arabia from GPS to set the working timezone; `TimezoneHelper` wraps the `timezone` package. Several `*_GUIDE.md` / `*_EXAMPLES.md` docs in `lib/common/helpers/` explain these.

### Configuration & secrets

API base URL and **all endpoint paths** are stored in `.env` and read through `envied` with `obfuscate: true`, exposed as `Env.<name>` (`constants/env.dart` + generated `env.g.dart`). Endpoints are not hardcoded in datasources — they reference `Env.*`. After changing `.env` or `env.dart`, rerun `build_runner`. In CI, the `.env` equivalent is provided as the base64 `DART_DEFINES` secret and decoded to `.env.prod`.

API requests wrap their payload in a `{"params": {...}}` envelope (Odoo-style JSON-RPC backend).

## Lint

Uses `very_good_analysis` (strict). Overrides in `analysis_options.yaml`: positional boolean params, 80-char line limit, single-quote preference, and public-member docs are all relaxed. `bricks/**` is excluded from analysis.

## CI/CD

`.github/workflows/build-upload.yaml` runs on a **self-hosted** runner, triggered manually or by `v*` tags. It auto-bumps the build number, signs, builds the Android AAB → Google Play (production track) and the iOS IPA → App Store Connect, then commits the version bump back. Firebase config files and signing material come from repo secrets/vars.
