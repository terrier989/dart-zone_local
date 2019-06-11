import 'dart:async';

class _Variable<T> {
  final T value;
  _Variable(this.value);
}

/// Implements zone-scoped values.
class ZoneLocal<T> {
  static bool _isEveryDefaultValueFrozen = false;
  T _defaultValue;
  bool _isDefaultValueImmutable = false;
  Object _zoneValuesKey; // Lazily initialized

  /// Constructs an instance that has the default value.
  ZoneLocal({T defaultValue}) : this._defaultValue = defaultValue;

  /// The current default value.
  T get defaultValue => _defaultValue;

  /// Changes the current default value.
  ///
  /// If [isDefaultValueImmutable] is `true`, this setter throws [StateError].
  set defaultValue(T value) {
    if (isDefaultValueImmutable) {
      throw StateError("Default value is immutable");
    }
    this._defaultValue = value;
  }

  @Deprecated("This feature will not be supported in the future")
  Object get zoneEntryKey {
    _zoneValuesKey ??= Object();
    return _zoneValuesKey;
  }

  /// Fills a map for [Zone.fork].
  void fillZoneValuesMap(Map<dynamic, dynamic> values, Object value) {
    _zoneValuesKey ??= Object();
    values[_zoneValuesKey] = new _Variable(value);
  }

  /// Tells whether [defaultValue] is immutable.
  ///
  /// You can make default values immutable with [freezeDefaultValue] and
  /// [Zone.freezeDefaultValues].
  bool get isDefaultValueImmutable =>
      _isEveryDefaultValueFrozen || this._isDefaultValueImmutable;

  @Deprecated("Use 'isDefaultValueImmutable'")
  bool get isDefaultValueFrozen => isDefaultValueImmutable;

  /// Returns the current zone-scoped value.
  T get value {
    final zoneValueKey = this._zoneValuesKey;
    if (zoneValueKey == null) {
      // Zones haven't been forked yet,
      // so we don't need to access the zone data at all.
      return defaultValue;
    }

    // Access zone data.
    final value = Zone.current[zoneValueKey];

    // Do we have a zone-local variable?
    if (value is _Variable) {
      return value.value;
    }
    return defaultValue;
  }

  /// Freezes the default value.
  ///
  /// If [isDefaultValueImmutable] is `true`, throws [StateError].
  /// After calling this method, [isDefaultValueImmutable] will be `true`.
  void freezeDefaultValue(T value) {
    this.defaultValue = value;
    this._isDefaultValueImmutable = true;
  }

  /// Creates a forked zone.
  ///
  /// Optional parameter `specification` is passed to [Zone.fork].
  Zone forkZoneWithValue(T value,
      {ZoneSpecification specification}) {
    // Construct a map
    final zoneValues = <dynamic, dynamic>{};
    fillZoneValuesMap(zoneValues, value);

    // Fork the current zone
    return Zone.current.fork(
      specification: specification,
      zoneValues: zoneValues,
    );
  }

  /// Creates a forked zone that has multiple changes.
  ///
  /// Optional parameter `specification` is passed to [Zone.fork].
  static Zone forkZoneWithValues(Map<ZoneLocal, Object> values,
      {ZoneSpecification specification}) {
    // Construct a map
    final zoneValues = <Object, Object>{};
    values.forEach((zoneLocal, zoneLocalValue) {
      zoneLocal.fillZoneValuesMap(zoneValues, zoneLocalValue);
    });

    // Fork the current zone
    return Zone.current.fork(
      specification: specification,
      zoneValues: zoneValues,
    );
  }

  /// Equal to calling [ZoneLocal.freezeDefaultValue] for every [ZoneLocal] in
  /// your application.
  ///
  /// This method is meant for giving confidence in immutability.
  static void freezeDefaultValues() {
    _isEveryDefaultValueFrozen = true;
  }
}
