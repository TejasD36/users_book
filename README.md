# Users Book

A Flutter app for fetching, storing, and managing users from API and local database (SQLite).

---

## ✨ Features

- Fetch users list from API (`https://jsonplaceholder.typicode.com/users`).
- Store users locally using **sqflite**.
- Load and merge data from API and local DB.
- View all users in a grid.
- View detailed user profile.
- Add new user with complete details (address, company).
- Offline-first approach: always show data from DB.
- Error handling with `ApiResponse` and `AppView`.
- Clean MVVM + Repository architecture.
- Navigation via **go_router**.

---

## 📂 Project Structure

```
lib/
  app/
    router/
      app_routes.dart
      route_name.dart
    providers.dart
    xcore.dart
  data/
    error/
      app_exception.dart
      failure.dart
    interceptor/
      network_interceptor.dart
    network/
      base_api_service.dart
      network_api_service.dart
    response/
      api_response.dart
      parser.dart
    services/
      database_service.dart
    xcore.dart
  features/
    main_page/
      model/
        users_list_response_model.dart
      repository/
        main_repository.dart
      view/
        add_user_view.dart
        home_view.dart
        user_details_view.dart
      view_model/
        main_view_model.dart
  resources/
    constants/
      api_url.dart
      constants.dart
      enums.dart
      global.dart
    widgets/
      app_error.dart
      app_loading.dart
      app_no_data.dart
      app_page_not_found.dart
      app_view.dart
  core.dart
  main.dart
```

---

## 🛠️ Dependencies

```
dependencies:
  flutter:
    sdk: flutter
  connectivity_plus: ^6.1.4
  cupertino_icons: ^1.0.8
  dartz: ^0.10.1
  dio: ^5.8.0+1
  go_router: ^16.0.0
  provider: ^6.1.5
  sqflite: ^2.4.2
  talker_dio_logger: ^4.9.1

dev_dependencies:
  flutter_test:
    sdk: flutter
```

---

## 🧩 Core Implementations

### ✅ API Integration
- `dio` used with `talker_dio_logger` for logging.
- API response parsed to `UsersListResponseModel`.
- Repository pattern (`main_repository.dart`).

---

### ✅ Database
- `sqflite` integration via `database_service.dart`.
- Tables:
    - `users` (with all fields: id, name, username, email, address parts, geo, company).
- Auto-generate `id` when adding new users manually.

---

### ✅ MVVM
- ViewModel (`main_view_model.dart`):
    - `getUsersList()`: fetch + upsert + merge local & API data.
    - `addUser()`: insert new user and notify listeners.
    - `getUserById()`: fetch single user details.

---

### ✅ UI
- `home_view.dart`: displays all users in a 2-column grid.
- `user_details_view.dart`: detailed user info card.
- `add_user_view.dart`: form to add new user with validation.
- `AppView`: handles loading/error/no data states.
- Beautiful material design.

---

### ✅ Navigation
- `go_router` with routes:
    - Home View
    - User Details View (accepts `userId`)
    - Add User View

---

### ✅ Permissions
**AndroidManifest.xml** includes:
```
<uses-permission android:name="android.permission.INTERNET"/>
```
to allow network requests.

---

## 🚀 Getting Started

1. Install dependencies:
   ```
   flutter pub get
   ```
2. Run the app:
   ```
   flutter run
   ```

---

## 🙌 Contributions
Feel free to fork and contribute!

---
