[![Pub Package](https://img.shields.io/pub/v/zone_local.svg)](https://pub.dartlang.org/packages/zone_local)
[![Github Actions CI](https://github.com/terrier989/zone_local/workflows/Dart%20CI/badge.svg)](https://github.com/terrier989/zone_local/actions?query=workflow%3A%22Dart+CI%22)

# Introduction
What's a zone? See [explanation of zones at dartlang.org](https://www.dartlang.org/articles/libraries/zones).

If you are declaring a static variable, this package gives you:
  * Type-safe zone-scoped mutability
  * Helpful methods for forking zones

# Getting Started
In `pubspec.yaml`:
```yaml
dependencies:
  zone_local: ^0.1.2
```

In `main.dart`:
```dart
import 'package:zone_local/zone_local.dart';

final ZoneLocal<String> greeting = new ZoneLocal<String>(defaultValue:"Hello!");

void main() {
  print(greeting.value);
  
  // Run a function in a forked zone that sees value "Hi!"
  greeting.forkZoneWithValue("Hi!").run(() {
    print(greeting.value);
  });
}
```
