# Interactive Vehicle Diagnostics 3D

A cross-platform Flutter application for interactive 3D vehicle diagnostics. This project fulfills the requirements for **Mobile Computing Lab Assignment 2** at FEUP. 

The application allows users to interact with a 3D model of a vehicle, scan physical QR codes of car components to jump directly to their 3D diagnostic views, and submit diagnostic reports to a cloud REST API.

## 🚀 Getting Started

Follow these steps to set up the project on your local machine.

### Prerequisites
* Flutter SDK (v3.24.0 or higher)
* Dart SDK
* Xcode (for macOS / iOS development)
* Android Studio (for Android development)

### Installation

1. **Clone the repository:**
   ```bash
   git clone git@github.com:MatviySuk/vehicle_diagnostics_3d.git
   cd vehicle_diagnostics_3d
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate Freezed data models:**
   Because this project uses immutable data models via the `freezed` and `json_serializable` packages, you must generate the boilerplate code before running the app.
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application:**
   You can run the application on macOS, iOS, or Android. (Note: testing the QR Scanner requires a physical device with a camera or a Mac for the desktop build).
   ```bash
   flutter run
   ```

## 🏗️ Architecture

This application strictly follows a 3-layer feature-driven architecture:

* **Presentation Layer (`lib/features/*/ui/`)**: Contains all Flutter widgets, screens, and the Flame 3D canvas. It listens to state changes from Riverpod providers.
* **Application Logic Layer (`lib/features/*/logic/`)**: Contains Riverpod `FutureProvider` and `AsyncNotifier` classes. It bridges the Data Layer to the Presentation Layer, handling loading and error states.
* **Data Layer (`lib/features/*/data/` & `domain/`)**: Contains the `Dio` REST client, repositories, and `freezed` data models. It communicates with the external Firebase REST API.

## 💾 Backend (Firebase REST API)

This application uses a real **Firebase Realtime Database** accessed purely via standard HTTP REST calls (`GET` and `POST`), completely avoiding the heavy Firebase Flutter SDK to adhere to assignment constraints.

* **Multi-User Isolation:** The app uses `shared_preferences` to generate and permanently store a unique `device_id`. All REST calls append this ID to the URL path (e.g., `/v1/users/<device_id>/vehicle/...`). This ensures that multiple developers and testers get their own isolated sandbox in the database.
* **Auto-Seeding:** If the database is empty for a new user, the `VehicleRepository` automatically issues a `PUT` request to seed the database with mock BMW data, ensuring a smooth first-run experience.

## 🧪 Testing and Code Quality

To ensure the codebase remains pristine, run the built-in static analysis and widget tests:

```bash
# Run static analysis
flutter analyze

# Run widget tests
flutter test
```
