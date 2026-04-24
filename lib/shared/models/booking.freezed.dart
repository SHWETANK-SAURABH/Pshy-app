// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Booking _$BookingFromJson(Map<String, dynamic> json) {
  return _Booking.fromJson(json);
}

/// @nodoc
mixin _$Booking {
  String get id => throw _privateConstructorUsedError;
  String get psychologistId => throw _privateConstructorUsedError;
  TimeSlot get slot => throw _privateConstructorUsedError;
  String get clientName => throw _privateConstructorUsedError;
  String get clientEmail => throw _privateConstructorUsedError;
  String get clientPhone => throw _privateConstructorUsedError;
  String get issueType => throw _privateConstructorUsedError;
  double get paidAmount => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // confirmed, rescheduled, completed
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingCopyWith<Booking> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCopyWith<$Res> {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) then) =
      _$BookingCopyWithImpl<$Res, Booking>;
  @useResult
  $Res call({
    String id,
    String psychologistId,
    TimeSlot slot,
    String clientName,
    String clientEmail,
    String clientPhone,
    String issueType,
    double paidAmount,
    String status,
    DateTime createdAt,
  });

  $TimeSlotCopyWith<$Res> get slot;
}

/// @nodoc
class _$BookingCopyWithImpl<$Res, $Val extends Booking>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? psychologistId = null,
    Object? slot = null,
    Object? clientName = null,
    Object? clientEmail = null,
    Object? clientPhone = null,
    Object? issueType = null,
    Object? paidAmount = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            psychologistId: null == psychologistId
                ? _value.psychologistId
                : psychologistId // ignore: cast_nullable_to_non_nullable
                      as String,
            slot: null == slot
                ? _value.slot
                : slot // ignore: cast_nullable_to_non_nullable
                      as TimeSlot,
            clientName: null == clientName
                ? _value.clientName
                : clientName // ignore: cast_nullable_to_non_nullable
                      as String,
            clientEmail: null == clientEmail
                ? _value.clientEmail
                : clientEmail // ignore: cast_nullable_to_non_nullable
                      as String,
            clientPhone: null == clientPhone
                ? _value.clientPhone
                : clientPhone // ignore: cast_nullable_to_non_nullable
                      as String,
            issueType: null == issueType
                ? _value.issueType
                : issueType // ignore: cast_nullable_to_non_nullable
                      as String,
            paidAmount: null == paidAmount
                ? _value.paidAmount
                : paidAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TimeSlotCopyWith<$Res> get slot {
    return $TimeSlotCopyWith<$Res>(_value.slot, (value) {
      return _then(_value.copyWith(slot: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingImplCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$$BookingImplCopyWith(
    _$BookingImpl value,
    $Res Function(_$BookingImpl) then,
  ) = __$$BookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String psychologistId,
    TimeSlot slot,
    String clientName,
    String clientEmail,
    String clientPhone,
    String issueType,
    double paidAmount,
    String status,
    DateTime createdAt,
  });

  @override
  $TimeSlotCopyWith<$Res> get slot;
}

/// @nodoc
class __$$BookingImplCopyWithImpl<$Res>
    extends _$BookingCopyWithImpl<$Res, _$BookingImpl>
    implements _$$BookingImplCopyWith<$Res> {
  __$$BookingImplCopyWithImpl(
    _$BookingImpl _value,
    $Res Function(_$BookingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? psychologistId = null,
    Object? slot = null,
    Object? clientName = null,
    Object? clientEmail = null,
    Object? clientPhone = null,
    Object? issueType = null,
    Object? paidAmount = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$BookingImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        psychologistId: null == psychologistId
            ? _value.psychologistId
            : psychologistId // ignore: cast_nullable_to_non_nullable
                  as String,
        slot: null == slot
            ? _value.slot
            : slot // ignore: cast_nullable_to_non_nullable
                  as TimeSlot,
        clientName: null == clientName
            ? _value.clientName
            : clientName // ignore: cast_nullable_to_non_nullable
                  as String,
        clientEmail: null == clientEmail
            ? _value.clientEmail
            : clientEmail // ignore: cast_nullable_to_non_nullable
                  as String,
        clientPhone: null == clientPhone
            ? _value.clientPhone
            : clientPhone // ignore: cast_nullable_to_non_nullable
                  as String,
        issueType: null == issueType
            ? _value.issueType
            : issueType // ignore: cast_nullable_to_non_nullable
                  as String,
        paidAmount: null == paidAmount
            ? _value.paidAmount
            : paidAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingImpl implements _Booking {
  const _$BookingImpl({
    required this.id,
    required this.psychologistId,
    required this.slot,
    required this.clientName,
    required this.clientEmail,
    required this.clientPhone,
    required this.issueType,
    required this.paidAmount,
    this.status = 'confirmed',
    required this.createdAt,
  });

  factory _$BookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingImplFromJson(json);

  @override
  final String id;
  @override
  final String psychologistId;
  @override
  final TimeSlot slot;
  @override
  final String clientName;
  @override
  final String clientEmail;
  @override
  final String clientPhone;
  @override
  final String issueType;
  @override
  final double paidAmount;
  @override
  @JsonKey()
  final String status;
  // confirmed, rescheduled, completed
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Booking(id: $id, psychologistId: $psychologistId, slot: $slot, clientName: $clientName, clientEmail: $clientEmail, clientPhone: $clientPhone, issueType: $issueType, paidAmount: $paidAmount, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.psychologistId, psychologistId) ||
                other.psychologistId == psychologistId) &&
            (identical(other.slot, slot) || other.slot == slot) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.clientEmail, clientEmail) ||
                other.clientEmail == clientEmail) &&
            (identical(other.clientPhone, clientPhone) ||
                other.clientPhone == clientPhone) &&
            (identical(other.issueType, issueType) ||
                other.issueType == issueType) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    psychologistId,
    slot,
    clientName,
    clientEmail,
    clientPhone,
    issueType,
    paidAmount,
    status,
    createdAt,
  );

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      __$$BookingImplCopyWithImpl<_$BookingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingImplToJson(this);
  }
}

abstract class _Booking implements Booking {
  const factory _Booking({
    required final String id,
    required final String psychologistId,
    required final TimeSlot slot,
    required final String clientName,
    required final String clientEmail,
    required final String clientPhone,
    required final String issueType,
    required final double paidAmount,
    final String status,
    required final DateTime createdAt,
  }) = _$BookingImpl;

  factory _Booking.fromJson(Map<String, dynamic> json) = _$BookingImpl.fromJson;

  @override
  String get id;
  @override
  String get psychologistId;
  @override
  TimeSlot get slot;
  @override
  String get clientName;
  @override
  String get clientEmail;
  @override
  String get clientPhone;
  @override
  String get issueType;
  @override
  double get paidAmount;
  @override
  String get status; // confirmed, rescheduled, completed
  @override
  DateTime get createdAt;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
