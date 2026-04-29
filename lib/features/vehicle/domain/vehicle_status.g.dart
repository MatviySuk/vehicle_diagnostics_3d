// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleStatusImpl _$$VehicleStatusImplFromJson(Map<String, dynamic> json) =>
    _$VehicleStatusImpl(
      vin: json['vin'] as String,
      mileageKm: (json['mileageKm'] as num).toDouble(),
      isDoorsLocked: json['isDoorsLocked'] as bool,
      frontLeftTirePressure: (json['frontLeftTirePressure'] as num).toDouble(),
      frontRightTirePressure: (json['frontRightTirePressure'] as num)
          .toDouble(),
      rearLeftTirePressure: (json['rearLeftTirePressure'] as num).toDouble(),
      rearRightTirePressure: (json['rearRightTirePressure'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$VehicleStatusImplToJson(_$VehicleStatusImpl instance) =>
    <String, dynamic>{
      'vin': instance.vin,
      'mileageKm': instance.mileageKm,
      'isDoorsLocked': instance.isDoorsLocked,
      'frontLeftTirePressure': instance.frontLeftTirePressure,
      'frontRightTirePressure': instance.frontRightTirePressure,
      'rearLeftTirePressure': instance.rearLeftTirePressure,
      'rearRightTirePressure': instance.rearRightTirePressure,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
