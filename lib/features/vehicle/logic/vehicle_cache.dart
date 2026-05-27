import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/vehicle_status.dart';
import 'vehicle_providers.dart';

const _kCacheKey = 'cached_vehicle_status';

class CachedVehicleStatus {
  final VehicleStatus status;
  final bool fromCache;

  const CachedVehicleStatus({required this.status, required this.fromCache});
}

Future<void> _saveVehicleCache(VehicleStatus status) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_kCacheKey, jsonEncode(status.toJson()));
}

Future<VehicleStatus?> _loadVehicleCache() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_kCacheKey);
  if (raw == null) return null;
  try {
    return VehicleStatus.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  } catch (_) {
    return null;
  }
}

// ING: Wraps vehicleStatusProvider with a SharedPreferences offline fallback.
// PT: Envolve vehicleStatusProvider com fallback offline em SharedPreferences.
final cachedVehicleStatusProvider = FutureProvider.autoDispose<CachedVehicleStatus>((ref) async {
  final timer = Timer.periodic(const Duration(seconds: 20), (_) => ref.invalidate(vehicleStatusProvider));
  ref.onDispose(timer.cancel);
  try {
    final status = await ref.watch(vehicleStatusProvider.future);
    await _saveVehicleCache(status);
    return CachedVehicleStatus(status: status, fromCache: false);
  } catch (_) {
    final cached = await _loadVehicleCache();
    if (cached != null) {
      return CachedVehicleStatus(status: cached, fromCache: true);
    }
    rethrow;
  }
});
