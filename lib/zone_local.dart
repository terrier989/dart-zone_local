import 'dart:async';

/// Implements zone-scoped values.
class ZoneLocal<T> {
  static final Object _null = Object(); // A helper for storing null value.
  static bool _isEveryDefaultValueFrozen = false;
  T _defaultValue;
  bool _isDefaultValueFrozen = false;
  Object _zoneValuesKey; // Lazily initialized

  /// Constructs an instance that has the default value.
  ZoneLocal({T defaultValue}) : this._defaultValue = defaultValue;

  /// The current default value.
  T get defaultValue => _defaultValue;

  /// Changes the current default value.
  ///
  /// If [isDefaultValueFrozen] is `true`, this setter throws [StateError].
  set defaultValue(T value) {
    if (isDefaultValueFrozen) {
      throw StateError("Default value is frozen");
    }
    this._defaultValue = value;
  }

  /// Returns map key for [Zone.fork] parameter `zoneValues`.
  Object get zoneEntryKey {
    _zoneValuesKey ??= Object();
    return _zoneValuesKey;
  }

  /// Fills a map that's used as [Zone.fork] parameter `zoneValues`.
  void fillZoneValuesMap(Map<dynamic, dynamic> values, Object value) {
    _zoneValuesKey ??= Object();
    if (value == null) {
      value = _null;
    }
    values[_zoneValuesKey] = value;
  }

  /// Tells whether [defaultValue] is frozen.
  ///
  /// You change the value with [freezeDefaultValue] and [Zone.freezeDefaultValues].
  bool get isDefaultValueFrozen =>
      _isEveryDefaultValueFrozen || this._isDefaultValueFrozen;

  /// Returns the current zone-scoped value.
  ///
  /// If none was defined by [Zone.current] (or parent zones), returns [defaultValue].
  T get value {
    final zoneValueKey = this._zoneValuesKey;
    if (zoneValueKey != null) {
      final value = Zone.current[zoneValueKey];
      if (value != null) {
        if (identical(_null, value)) {
          return null;
        }
        return value;
      }
    }
    return defaultValue;
  }

  /// Freezes the default value.
  ///
  /// If [isDefaultValueFrozen] is `true`, throws [StateError].
  /// After calling this method, [isDefaultValueFrozen] will be `true`.
  void freezeDefaultValue(T value) {
    this.defaultValue = value;
    this._isDefaultValueFrozen = true;
  }

  /// A convenience method for creating a fork of [Zone.current] where
  /// [value] is mutated for this instance.
  ///
  /// Optional parameter `specification` is passed to [Zone.fork].
  Zone forkZoneWithValue(T value, {ZoneSpecification specification}) {
    final zoneValues = <dynamic, dynamic>{};
    fillZoneValuesMap(zoneValues, value);
    return Zone.current
        .fork(specification: specification, zoneValues: zoneValues);
  }

  /// A convenience method for creating a fork of [Zone.current] where
  /// [value] is mutated for multiple [ZoneLocal] instances.
  ///
  /// Optional parameter `specification` is passed to [Zone.fork].
  static Zone forkZoneWithValues(Map<ZoneLocal, Object> values,
      {ZoneSpecification specification}) {
    final zoneValues = <Object, Object>{};
    values.forEach((zoneLocal, zoneLocalValue) {
      zoneLocal.fillZoneValuesMap(zoneValues, zoneLocalValue);
    });
    return Zone.current
        .fork(specification: specification, zoneValues: zoneValues);
  }

  /// Freezes default values of all ZoneLocal values in your application.
  ///
  /// After calling this method, [isDefaultValueFrozen] of every [ZoneLocal] will be `true`.
  static void freezeDefaultValues() {
    _isEveryDefaultValueFrozen = true;
  }
}
