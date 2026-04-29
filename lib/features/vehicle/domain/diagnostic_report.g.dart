// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnostic_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiagnosticReportImpl _$$DiagnosticReportImplFromJson(
  Map<String, dynamic> json,
) => _$DiagnosticReportImpl(
  componentId: json['componentId'] as String,
  description: json['description'] as String,
  severity: json['severity'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$$DiagnosticReportImplToJson(
  _$DiagnosticReportImpl instance,
) => <String, dynamic>{
  'componentId': instance.componentId,
  'description': instance.description,
  'severity': instance.severity,
  'timestamp': instance.timestamp.toIso8601String(),
};
