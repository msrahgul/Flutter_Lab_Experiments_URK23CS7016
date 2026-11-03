# Firebase setup for Experiments 7–10

Each experiment is a separate Flutter app. You can use one Firebase project for all four, but run FlutterFire configuration separately from each experiment folder so each app gets its own `lib/firebase_options.dart`.

## One-time Firebase tools setup

1. Install [Git for Windows](https://git-scm.com/download/win), select the option to make Git available from the command line, reopen PowerShell, and confirm `git --version` works. Flutter uses Git to determine its engine version; the pasted output shows Git is currently missing from PATH.
2. Enable Windows Developer Mode before running `flutter pub get`. These projects include Windows runners, so Flutter needs permission to create plugin symlinks even if you launch Chrome. Open Settings with:

   ```powershell
   start ms-settings:developers
   ```

   Turn on **Developer Mode** in Settings, then reopen the terminal. This setting requires administrator access ([Microsoft instructions](https://learn.microsoft.com/en-us/windows/apps/get-started/developer-mode-features-and-debugging)).

3. Select the Firebase project `flutterurk23cs7016` in the [Firebase Console](https://console.firebase.google.com/).
4. Install the Firebase CLI and sign in:

   ```powershell
   npm install -g firebase-tools
   firebase login
   ```

5. Install FlutterFire CLI:

   ```powershell
   dart pub global activate flutterfire_cli
   ```

## Configure each experiment

Run these commands from the repository root in PowerShell. The script checks each command and stops at the first failure so later apps are not attempted with incomplete configuration.

```powershell
$projectId = 'flutterurk23cs7016'
$ErrorActionPreference = 'Stop'
$experiments = @(
  'exp07_firestore_employees',
  'exp08_firestore_search',
  'exp09_firestore_update',
  'exp10_firestore_login'
)

foreach ($experiment in $experiments) {
  Push-Location $experiment
  try {
    flutter create .
    if ($LASTEXITCODE -ne 0) { throw "flutter create failed in $experiment" }

    flutter pub get
    if ($LASTEXITCODE -ne 0) { throw "flutter pub get failed in $experiment" }

    dart pub global run flutterfire_cli:flutterfire configure `
      --project=$projectId `
      --platforms=android,web,windows
    if ($LASTEXITCODE -ne 0) { throw "FlutterFire configuration failed in $experiment" }
  }
  finally {
    Pop-Location
  }
}
```

FlutterFire replaces each placeholder `lib/firebase_options.dart` with the configuration for the selected Firebase project and platforms. The Developer Mode step above resolves the plugin symlink error shown in the pasted output. Firebase lists Windows support as beta for local development; use Chrome or Android for the stable targets.

Enable **Cloud Firestore** in the Firebase Console. Test mode is suitable only for this lab; replace its open rules before using the project with real data. Then run an experiment from its folder:

```powershell
cd exp07_firestore_employees
flutter run -d chrome
```

For an Android emulator or phone, run `flutter devices` to find its ID, then use `flutter run -d <device-id>`. Repeat with `exp08_firestore_search`, `exp09_firestore_update`, or `exp10_firestore_login` as needed.

## Data expected by each app

- **Experiment 7:** Saving an employee creates the `employees` collection. Fields: `name`, `empId`, `department`, `salary`.
- **Experiments 8 and 9:** Create a `books` collection. Each document should include `id`, `title`, `author`, and numeric `copies`. Experiment 8 searches by title; Experiment 9 updates `copies`.
- **Experiment 10:** Create a `users` collection. Each document should include `name`, `email`, `phone`, and `password`. The login screen looks up these fields in Firestore.

Experiment 10 is a Firestore login exercise, not production authentication. Use dummy accounts only; do not store real passwords in Firestore.

The placeholder options files do not contain real Firebase configuration. Run the configuration commands before launching these apps. Do not commit personal service-account keys; FlutterFire's generated client options are app configuration, not admin credentials.
