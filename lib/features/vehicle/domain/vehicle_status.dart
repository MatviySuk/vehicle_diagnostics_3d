import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_status.freezed.dart';
part 'vehicle_status.g.dart';

@freezed
class VehicleStatus with _$VehicleStatus {
  const factory VehicleStatus({
    required String vin,
    required double mileageKm,
    required bool isDoorsLocked,
    required double frontLeftTirePressure,
    required double frontRightTirePressure,
    required double rearLeftTirePressure,
    required double rearRightTirePressure,
    required DateTime lastUpdated,
  }) = _VehicleStatus;

  factory VehicleStatus.fromJson(Map<String, dynamic> json) =>
      _$VehicleStatusFromJson(json);
}
