import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

final deviceIdProvider = Provider<String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  const key = 'device_id';
  
  String? deviceId = prefs.getString(key);
  if (deviceId == null) {
    // Generate a simple random device ID like: device_1234-5678-9012-3456
    final random = Random();
    final parts = List.generate(4, (_) => random.nextInt(9999).toString().padLeft(4, '0'));
    deviceId = 'device_${parts.join('-')}';
    prefs.setString(key, deviceId);
  }
  
  return deviceId;
});
