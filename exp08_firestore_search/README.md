# Exercise 8 - Firestore Data Retrieval (Library Book Search)
Course 24CS2016 - Building Application using Flutter | URK23CS7016

## Run
```
cd exp08_firestore_search
flutter create .      # generates android/ios/web folders (keeps lib/main.dart & pubspec.yaml)
flutter pub get
flutter run
```

## Firebase setup (required)
1. Create a project at https://console.firebase.google.com and enable **Firestore Database** (test mode).
2. Install tools once: `dart pub global activate flutterfire_cli` (and install Firebase CLI, then `firebase login`).
3. In this folder run `flutterfire configure` and choose your project/platforms. This overwrites `lib/firebase_options.dart`.
4. Create collection `books` with documents having fields `id`, `title`, `author`, `copies` (number).
