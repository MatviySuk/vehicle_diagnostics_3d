import 'package:freezed_annotation/freezed_annotation.dart';

part 'diagnostic_report.freezed.dart';
part 'diagnostic_report.g.dart';

@freezed
class DiagnosticReport with _$DiagnosticReport {
  const factory DiagnosticReport({
    required String componentId,
    required String description,
    required String severity, // 'low', 'medium', 'high', 'critical'
    required DateTime timestamp,
  }) = _DiagnosticReport;

  factory DiagnosticReport.fromJson(Map<String, dynamic> json) =>
      _$DiagnosticReportFromJson(json);
}
