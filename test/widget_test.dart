// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_diagnostics_3d/main.dart';
import 'package:vehicle_diagnostics_3d/core/device/device_id_provider.dart';

void main() {
  testWidgets('App launches and renders dashboard', (WidgetTester tester) async {
    // Mock SharedPreferences for the test
    SharedPreferences.setMockInitialValues({'device_id': 'test_device_id'});
    final sharedPreferences = await SharedPreferences.getInstance();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const VehicleDiagnosticsApp(),
      ),
    );

    // Verify that the Dashboard screen title is present
    expect(find.text('Vehicle Diagnostics Dashboard'), findsOneWidget);
  });
}
