# Exercise 10 - User Login Authentication using Firestore
Course 24CS2016 - Building Application using Flutter | URK23CS7016

## Run
```
cd exp10_firestore_login
flutter create .      # generates android/ios/web folders (keeps lib/main.dart & pubspec.yaml)
flutter pub get
flutter run -d chrome
```

## Firebase setup (required)

Follow the repository's [Firebase setup guide](../FIREBASE_SETUP.md) to configure this app and generate its Firebase options. Create the `users` collection with `name`, `email`, `phone`, and `password` fields.
