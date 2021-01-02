import 'dart:async';

/// Implements zone-scoped values.
/// See [explanation of zones at dartlang.org](https://www.dartlang.org/articles/libraries/zones).
///
/// # Example
/// ```dart
/// import 'package:zone_local/zone_local.dart';
///
/// final ZoneLocal<String> greeting = new ZoneLocal<String>(
///   defaultValue: 'Hello!',
/// );
///
/// void main() {
///   // This zone sees the default value.
///   print(greeting.value); // Hello!
///
///   // Fork a zone with a different value.
///   final zone = greeting.forkZoneWithValue('Hi!');
///   zone.run(() {
///     print(greeting.value); // Hi!
///   });
/// }
/// ```
class ZoneLocal<T> {
  T _defaultValue;
  bool _isFrozen = false;
  Object? _zoneValuesKey;

  /// Constructs an instance that has the default value.
  ZoneLocal({required T defaultValue}) : _defaultValue = defaultValue;

  /// The current default value.
  T get defaultValue => _defaultValue;

  /// Changes the current default value.
  set defaultValue(T value) {
    if (_isFrozen) {
      throw StateError('Default value is immutable');
    }
    _defaultValue = value;
  }

  /// Key for forking zones.
  Object get key => _zoneValuesKey ??= Object();

  /// Returns the current zone-scoped value.
  T get value {
    final key = _zoneValuesKey;
    if (key == null) {
      // Zones haven't been forked yet,
      return defaultValue;
    }
    final value = Zone.current[key];
    if (value!=null && value is T) {
      return value;
    }
    return defaultValue;
  }

  /// {@nodoc}
  @Deprecated('use key')
  Object get zoneEntryKey => key;

  /// Forks a new zone. See example for [ZoneLocal].
  Zone forkZoneWithValue(T value) {
    return Zone.current.fork(zoneValues: {
      key: value,
    });
  }

  /// Prevents further mutations of the default value.
  void freezeDefaultValue(T value) {
    defaultValue = value;
    _isFrozen = true;
  }
}
