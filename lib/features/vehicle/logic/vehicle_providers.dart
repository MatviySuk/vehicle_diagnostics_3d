import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/vehicle_repository.dart';
import '../domain/diagnostic_report.dart';
import '../domain/vehicle_status.dart';

final vehicleStatusProvider = FutureProvider.autoDispose<VehicleStatus>((ref) {
  final repository = ref.watch(vehicleRepositoryProvider);
  return repository.getVehicleStatus();
});

final diagnosticReportControllerProvider =
    AsyncNotifierProvider<DiagnosticReportController, void>(() {
  return DiagnosticReportController();
});

class DiagnosticReportController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submitReport(String componentId, String description, String severity) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(vehicleRepositoryProvider);
      final report = DiagnosticReport(
        componentId: componentId,
        description: description,
        severity: severity,
        timestamp: DateTime.now(),
      );
      await repository.submitDiagnosticReport(report);
    });
  }
}
