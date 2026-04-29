import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/device/device_id_provider.dart';
import '../domain/diagnostic_report.dart';
import '../domain/vehicle_status.dart';

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepository(ref.watch(dioProvider), ref.watch(deviceIdProvider));
});

class VehicleRepository {
  final Dio _dio;
  final String _deviceId;

  VehicleRepository(this._dio, this._deviceId);

  Future<VehicleStatus> getVehicleStatus() async {
    try {
      final response = await _dio.get('/v1/users/$_deviceId/vehicle/status.json');
      
      // Firebase RTDB returns null if the node doesn't exist yet
      if (response.data == null) {
        // If the database is empty, let's create the default mock BMW status and return it
        final defaultStatus = VehicleStatus(
          vin: 'WBA${_deviceId.replaceAll('-', '').substring(0, 14)}',
          mileageKm: 45231.5,
          isDoorsLocked: true,
          frontLeftTirePressure: 2.4,
          frontRightTirePressure: 2.4,
          rearLeftTirePressure: 2.6,
          rearRightTirePressure: 2.5,
          lastUpdated: DateTime.now(),
        );
        
        // Seed the database so future calls get real data
        await _dio.put('/v1/users/$_deviceId/vehicle/status.json', data: defaultStatus.toJson());
        
        return defaultStatus;
      }

      return VehicleStatus.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to fetch vehicle status: ${e.message}');
    }
  }

  Future<void> submitDiagnosticReport(DiagnosticReport report) async {
    try {
      // Use POST to push a new item to a list in Firebase RTDB scoped by device ID
      await _dio.post(
        '/v1/users/$_deviceId/vehicle/diagnostics.json',
        data: report.toJson(),
      );
    } on DioException catch (e) {
      throw Exception('Failed to submit diagnostic report: ${e.message}');
    }
  }
}
