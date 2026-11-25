# Auth App

A Flutter app with sign up, login, a dashboard and an editable profile. It uses Firebase Authentication to manage accounts and Cloud Firestore to store each user's details.

## Features

- Welcome screen with Sign Up and Log In buttons
- Sign up with first name, last name, date of birth, state, country, email and password
- Confirm-password check and a show/hide eye icon on the password fields
- Log in with friendly error messages
- Dashboard showing the user's full name and email
- Edit profile screen that saves changes to Firestore
- Stays logged in after the app is closed, and log out

## Built with

- Flutter and Dart
- Firebase Authentication
- Cloud Firestore
- Provider (state management)

## How it works

- Accounts are created and checked by Firebase Authentication.
- Each user's details are saved in a Firestore `users` collection, in a document named after their user ID.
- Firestore rules allow users to read and write only their own document.
- Provider shares the logged-in user across the app, and an auth gate shows the welcome screen or the dashboard depending on whether someone is logged in.

## Run it yourself

1. Install Flutter and clone this repository.
2. Create your own Firebase project and turn on **Email/Password** sign-in and **Firestore**.
3. Run `flutterfire configure` inside the project folder to connect it to your Firebase project.
4. Run `flutter pub get`, then `flutter run`.

## Author

Sherif Ayo - [GitHub](https://github.com/S-Ayo1)