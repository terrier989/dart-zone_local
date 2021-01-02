[![Pub Package](https://img.shields.io/pub/v/zone_local.svg)](https://pub.dartlang.org/packages/zone_local)
[![Github Actions CI](https://github.com/terrier989/zone_local/workflows/Dart%20CI/badge.svg)](https://github.com/terrier989/zone_local/actions?query=workflow%3A%22Dart+CI%22)

# Introduction
A simple, type-safe package for declaring static variables that may have zone-scoped values.
These are similar to _ThreadLocal_ values in programming languages such as Java.

See [explanation of zones at dartlang.org](https://www.dartlang.org/articles/libraries/zones).

# Getting Started
## 1.Add dependency
In `pubspec.yaml`:
```yaml
dependencies:
  zone_local: ^0.2.0-nullsafety.0
```

## 2.Usage
```dart
import 'package:zone_local/zone_local.dart';

final ZoneLocal<String> greeting = new ZoneLocal<String>(
  defaultValue: 'Hello!',
);

void main() {
  // This zone sees the default value.
  print(greeting.value); // Hello!

  // Fork a zone that will see a different value when the zoneLocal is accessed.
  final zone = greeting.forkZoneWithValue('Hi!');
  zone.run(() {
    print(greeting.value); // Hi!
  });
}
```