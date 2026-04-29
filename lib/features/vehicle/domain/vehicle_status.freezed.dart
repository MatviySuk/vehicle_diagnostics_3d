// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VehicleStatus _$VehicleStatusFromJson(Map<String, dynamic> json) {
  return _VehicleStatus.fromJson(json);
}

/// @nodoc
mixin _$VehicleStatus {
  String get vin => throw _privateConstructorUsedError;
  double get mileageKm => throw _privateConstructorUsedError;
  bool get isDoorsLocked => throw _privateConstructorUsedError;
  double get frontLeftTirePressure => throw _privateConstructorUsedError;
  double get frontRightTirePressure => throw _privateConstructorUsedError;
  double get rearLeftTirePressure => throw _privateConstructorUsedError;
  double get rearRightTirePressure => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this VehicleStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VehicleStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleStatusCopyWith<VehicleStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleStatusCopyWith<$Res> {
  factory $VehicleStatusCopyWith(
    VehicleStatus value,
    $Res Function(VehicleStatus) then,
  ) = _$VehicleStatusCopyWithImpl<$Res, VehicleStatus>;
  @useResult
  $Res call({
    String vin,
    double mileageKm,
    bool isDoorsLocked,
    double frontLeftTirePressure,
    double frontRightTirePressure,
    double rearLeftTirePressure,
    double rearRightTirePressure,
    DateTime lastUpdated,
  });
}

/// @nodoc
class _$VehicleStatusCopyWithImpl<$Res, $Val extends VehicleStatus>
    implements $VehicleStatusCopyWith<$Res> {
  _$VehicleStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VehicleStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vin = null,
    Object? mileageKm = null,
    Object? isDoorsLocked = null,
    Object? frontLeftTirePressure = null,
    Object? frontRightTirePressure = null,
    Object? rearLeftTirePressure = null,
    Object? rearRightTirePressure = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _value.copyWith(
            vin: null == vin
                ? _value.vin
                : vin // ignore: cast_nullable_to_non_nullable
                      as String,
            mileageKm: null == mileageKm
                ? _value.mileageKm
                : mileageKm // ignore: cast_nullable_to_non_nullable
                      as double,
            isDoorsLocked: null == isDoorsLocked
                ? _value.isDoorsLocked
                : isDoorsLocked // ignore: cast_nullable_to_non_nullable
                      as bool,
            frontLeftTirePressure: null == frontLeftTirePressure
                ? _value.frontLeftTirePressure
                : frontLeftTirePressure // ignore: cast_nullable_to_non_nullable
                      as double,
            frontRightTirePressure: null == frontRightTirePressure
                ? _value.frontRightTirePressure
                : frontRightTirePressure // ignore: cast_nullable_to_non_nullable
                      as double,
            rearLeftTirePressure: null == rearLeftTirePressure
                ? _value.rearLeftTirePressure
                : rearLeftTirePressure // ignore: cast_nullable_to_non_nullable
                      as double,
            rearRightTirePressure: null == rearRightTirePressure
                ? _value.rearRightTirePressure
                : rearRightTirePressure // ignore: cast_nullable_to_non_nullable
                      as double,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VehicleStatusImplCopyWith<$Res>
    implements $VehicleStatusCopyWith<$Res> {
  factory _$$VehicleStatusImplCopyWith(
    _$VehicleStatusImpl value,
    $Res Function(_$VehicleStatusImpl) then,
  ) = __$$VehicleStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String vin,
    double mileageKm,
    bool isDoorsLocked,
    double frontLeftTirePressure,
    double frontRightTirePressure,
    double rearLeftTirePressure,
    double rearRightTirePressure,
    DateTime lastUpdated,
  });
}

/// @nodoc
class __$$VehicleStatusImplCopyWithImpl<$Res>
    extends _$VehicleStatusCopyWithImpl<$Res, _$VehicleStatusImpl>
    implements _$$VehicleStatusImplCopyWith<$Res> {
  __$$VehicleStatusImplCopyWithImpl(
    _$VehicleStatusImpl _value,
    $Res Function(_$VehicleStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VehicleStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vin = null,
    Object? mileageKm = null,
    Object? isDoorsLocked = null,
    Object? frontLeftTirePressure = null,
    Object? frontRightTirePressure = null,
    Object? rearLeftTirePressure = null,
    Object? rearRightTirePressure = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _$VehicleStatusImpl(
        vin: null == vin
            ? _value.vin
            : vin // ignore: cast_nullable_to_non_nullable
                  as String,
        mileageKm: null == mileageKm
            ? _value.mileageKm
            : mileageKm // ignore: cast_nullable_to_non_nullable
                  as double,
        isDoorsLocked: null == isDoorsLocked
            ? _value.isDoorsLocked
            : isDoorsLocked // ignore: cast_nullable_to_non_nullable
                  as bool,
        frontLeftTirePressure: null == frontLeftTirePressure
            ? _value.frontLeftTirePressure
            : frontLeftTirePressure // ignore: cast_nullable_to_non_nullable
                  as double,
        frontRightTirePressure: null == frontRightTirePressure
            ? _value.frontRightTirePressure
            : frontRightTirePressure // ignore: cast_nullable_to_non_nullable
                  as double,
        rearLeftTirePressure: null == rearLeftTirePressure
            ? _value.rearLeftTirePressure
            : rearLeftTirePressure // ignore: cast_nullable_to_non_nullable
                  as double,
        rearRightTirePressure: null == rearRightTirePressure
            ? _value.rearRightTirePressure
            : rearRightTirePressure // ignore: cast_nullable_to_non_nullable
                  as double,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleStatusImpl implements _VehicleStatus {
  const _$VehicleStatusImpl({
    required this.vin,
    required this.mileageKm,
    required this.isDoorsLocked,
    required this.frontLeftTirePressure,
    required this.frontRightTirePressure,
    required this.rearLeftTirePressure,
    required this.rearRightTirePressure,
    required this.lastUpdated,
  });

  factory _$VehicleStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleStatusImplFromJson(json);

  @override
  final String vin;
  @override
  final double mileageKm;
  @override
  final bool isDoorsLocked;
  @override
  final double frontLeftTirePressure;
  @override
  final double frontRightTirePressure;
  @override
  final double rearLeftTirePressure;
  @override
  final double rearRightTirePressure;
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'VehicleStatus(vin: $vin, mileageKm: $mileageKm, isDoorsLocked: $isDoorsLocked, frontLeftTirePressure: $frontLeftTirePressure, frontRightTirePressure: $frontRightTirePressure, rearLeftTirePressure: $rearLeftTirePressure, rearRightTirePressure: $rearRightTirePressure, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleStatusImpl &&
            (identical(other.vin, vin) || other.vin == vin) &&
            (identical(other.mileageKm, mileageKm) ||
                other.mileageKm == mileageKm) &&
            (identical(other.isDoorsLocked, isDoorsLocked) ||
                other.isDoorsLocked == isDoorsLocked) &&
            (identical(other.frontLeftTirePressure, frontLeftTirePressure) ||
                other.frontLeftTirePressure == frontLeftTirePressure) &&
            (identical(other.frontRightTirePressure, frontRightTirePressure) ||
                other.frontRightTirePressure == frontRightTirePressure) &&
            (identical(other.rearLeftTirePressure, rearLeftTirePressure) ||
                other.rearLeftTirePressure == rearLeftTirePressure) &&
            (identical(other.rearRightTirePressure, rearRightTirePressure) ||
                other.rearRightTirePressure == rearRightTirePressure) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    vin,
    mileageKm,
    isDoorsLocked,
    frontLeftTirePressure,
    frontRightTirePressure,
    rearLeftTirePressure,
    rearRightTirePressure,
    lastUpdated,
  );

  /// Create a copy of VehicleStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleStatusImplCopyWith<_$VehicleStatusImpl> get copyWith =>
      __$$VehicleStatusImplCopyWithImpl<_$VehicleStatusImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleStatusImplToJson(this);
  }
}

abstract class _VehicleStatus implements VehicleStatus {
  const factory _VehicleStatus({
    required final String vin,
    required final double mileageKm,
    required final bool isDoorsLocked,
    required final double frontLeftTirePressure,
    required final double frontRightTirePressure,
    required final double rearLeftTirePressure,
    required final double rearRightTirePressure,
    required final DateTime lastUpdated,
  }) = _$VehicleStatusImpl;

  factory _VehicleStatus.fromJson(Map<String, dynamic> json) =
      _$VehicleStatusImpl.fromJson;

  @override
  String get vin;
  @override
  double get mileageKm;
  @override
  bool get isDoorsLocked;
  @override
  double get frontLeftTirePressure;
  @override
  double get frontRightTirePressure;
  @override
  double get rearLeftTirePressure;
  @override
  double get rearRightTirePressure;
  @override
  DateTime get lastUpdated;

  /// Create a copy of VehicleStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleStatusImplCopyWith<_$VehicleStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
