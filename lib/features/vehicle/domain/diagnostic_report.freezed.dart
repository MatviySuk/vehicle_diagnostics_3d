// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diagnostic_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DiagnosticReport _$DiagnosticReportFromJson(Map<String, dynamic> json) {
  return _DiagnosticReport.fromJson(json);
}

/// @nodoc
mixin _$DiagnosticReport {
  String get componentId => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get severity =>
      throw _privateConstructorUsedError; // 'low', 'medium', 'high', 'critical'
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this DiagnosticReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiagnosticReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiagnosticReportCopyWith<DiagnosticReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiagnosticReportCopyWith<$Res> {
  factory $DiagnosticReportCopyWith(
    DiagnosticReport value,
    $Res Function(DiagnosticReport) then,
  ) = _$DiagnosticReportCopyWithImpl<$Res, DiagnosticReport>;
  @useResult
  $Res call({
    String componentId,
    String description,
    String severity,
    DateTime timestamp,
  });
}

/// @nodoc
class _$DiagnosticReportCopyWithImpl<$Res, $Val extends DiagnosticReport>
    implements $DiagnosticReportCopyWith<$Res> {
  _$DiagnosticReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiagnosticReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? componentId = null,
    Object? description = null,
    Object? severity = null,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            componentId: null == componentId
                ? _value.componentId
                : componentId // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            severity: null == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiagnosticReportImplCopyWith<$Res>
    implements $DiagnosticReportCopyWith<$Res> {
  factory _$$DiagnosticReportImplCopyWith(
    _$DiagnosticReportImpl value,
    $Res Function(_$DiagnosticReportImpl) then,
  ) = __$$DiagnosticReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String componentId,
    String description,
    String severity,
    DateTime timestamp,
  });
}

/// @nodoc
class __$$DiagnosticReportImplCopyWithImpl<$Res>
    extends _$DiagnosticReportCopyWithImpl<$Res, _$DiagnosticReportImpl>
    implements _$$DiagnosticReportImplCopyWith<$Res> {
  __$$DiagnosticReportImplCopyWithImpl(
    _$DiagnosticReportImpl _value,
    $Res Function(_$DiagnosticReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiagnosticReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? componentId = null,
    Object? description = null,
    Object? severity = null,
    Object? timestamp = null,
  }) {
    return _then(
      _$DiagnosticReportImpl(
        componentId: null == componentId
            ? _value.componentId
            : componentId // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        severity: null == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiagnosticReportImpl implements _DiagnosticReport {
  const _$DiagnosticReportImpl({
    required this.componentId,
    required this.description,
    required this.severity,
    required this.timestamp,
  });

  factory _$DiagnosticReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiagnosticReportImplFromJson(json);

  @override
  final String componentId;
  @override
  final String description;
  @override
  final String severity;
  // 'low', 'medium', 'high', 'critical'
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'DiagnosticReport(componentId: $componentId, description: $description, severity: $severity, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiagnosticReportImpl &&
            (identical(other.componentId, componentId) ||
                other.componentId == componentId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, componentId, description, severity, timestamp);

  /// Create a copy of DiagnosticReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiagnosticReportImplCopyWith<_$DiagnosticReportImpl> get copyWith =>
      __$$DiagnosticReportImplCopyWithImpl<_$DiagnosticReportImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DiagnosticReportImplToJson(this);
  }
}

abstract class _DiagnosticReport implements DiagnosticReport {
  const factory _DiagnosticReport({
    required final String componentId,
    required final String description,
    required final String severity,
    required final DateTime timestamp,
  }) = _$DiagnosticReportImpl;

  factory _DiagnosticReport.fromJson(Map<String, dynamic> json) =
      _$DiagnosticReportImpl.fromJson;

  @override
  String get componentId;
  @override
  String get description;
  @override
  String get severity; // 'low', 'medium', 'high', 'critical'
  @override
  DateTime get timestamp;

  /// Create a copy of DiagnosticReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiagnosticReportImplCopyWith<_$DiagnosticReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
