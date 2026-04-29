# Mobile Computing Lab 2: Assignment Requirements Mapping

This document maps the official Lab Assignment 2 requirements to the current implementation in this repository. It serves as a checklist for what is already completed and a guide for teammates (Mahmud and Agostinho) on where to implement their remaining features.

---

## ✅ Completed Requirements (Backend & Architecture - Matviy)

### 3.1 Platform and Toolchain
* **Requirement:** Developed using Flutter and Dart. Build and execute on Android.
* **Status:** **Completed.** App is scaffolded for Android, iOS, and macOS.

### 3.3 REST Integration and Asynchronous Processing
* **Requirement:** Perform `GET`, `POST`/`PUT` requests asynchronously, handle errors, show loading states.
* **Status:** **Completed.** 
  * Implemented using `Dio` (`lib/core/network/dio_client.dart`).
  * Connects to a real **Firebase Realtime Database REST API**.
  * **GET:** Fetches vehicle status asynchronously (`lib/features/vehicle/data/vehicle_repository.dart`).
  * **POST:** Submits diagnostic reports asynchronously.
  * **Async States:** Handled cleanly via Riverpod's `AsyncValue` (`.loading`, `.error`, `.data`) in `lib/features/dashboard/ui/dashboard_screen.dart` and `lib/features/vehicle/ui/component_detail_screen.dart`.

### 3.5 Architectural Organization
* **Requirement:** Clear separation between Presentation layer, Application logic, and Data layer.
* **Status:** **Completed.** 
  * Strict folder structure separates `ui/`, `logic/`, `data/`, and `domain/` inside the `lib/features/` directory.

### 3.6 Device Capability Integration
* **Requirement:** Integrate at least one device-level capability (e.g., camera) that influences application behavior.
* **Status:** **Completed.** 
  * Implemented `mobile_scanner` in `lib/features/scanner/ui/qr_scanner_screen.dart`.
  * **Meaningful Integration:** Scanning a QR code of a car part (e.g., `PART_ID:headlight_left`) alters the `GoRouter` navigation to instantly jump to that specific component's 3D detail view (`context.push('/component/$result')`).
  * OS Permissions added to Android, iOS, and macOS manifests/entitlements.

### Local Data Persistence (3.7 optional extra)
* **Status:** **Completed.** 
  * Implemented `shared_preferences` in `lib/core/device/device_id_provider.dart` to save a permanent unique device ID, allowing isolated multi-user database access.

---

## 🛠️ Pending Implementation (Mahmud & Agostinho)

### 3.2 User Interface and Navigation (Mahmud)
* **Requirement:** Minimum 4 distinct screens, screen-to-screen navigation, form handling.
* **Current State:** 5 placeholder screens exist, connected via `GoRouter`. A fully functional validated form exists in `ComponentDetailScreen`.
* **Mahmud's Tasks:** 
  1. Replace the UI in `lib/features/dashboard/ui/dashboard_screen.dart` with the final dashboard design. You can access vehicle data using `ref.watch(vehicleStatusProvider)`.
  2. Implement the UI in `lib/features/maintenance/ui/maintenance_history_screen.dart`.
  3. Polish the UI surrounding Agostinho's 3D models in `lib/features/vehicle/ui/car_3d_screen.dart` and `component_detail_screen.dart`.

### 3.4 Visualization or Custom Drawing (Agostinho)
* **Requirement:** Include custom drawing, data visualization, or dynamic graphical representation.
* **Current State:** Placeholder `Container` widgets exist where the 3D models should go.
* **Agostinho's Tasks:**
  1. Integrate the `Flame 3D` engine into the project.
  2. Replace the placeholder container in `lib/features/vehicle/ui/car_3d_screen.dart` with the full 3D interactive vehicle model. Add gestures to trigger `context.push('/component/[part_id]')` when a user taps a component.
  3. Replace the placeholder container in `lib/features/vehicle/ui/component_detail_screen.dart` with the isolated, rotating 3D view of the specific component passed via the `widget.componentId` variable.

---

## 🧭 Project Navigation Guide for Teammates

* **Need to change routing?** Look in `lib/core/router/app_router.dart`.
* **Need to trigger a POST request?** Call `ref.read(diagnosticReportControllerProvider.notifier).submitReport(...)` (See example in `component_detail_screen.dart`).
* **Need to fetch vehicle data for a screen?** Call `ref.watch(vehicleStatusProvider)` inside a `ConsumerWidget`.
