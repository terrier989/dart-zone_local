# Introduction
What's a zone? See [explanation of zones at dartlang.org](https://www.dartlang.org/articles/libraries/zones).

If you are declaring a static variable, this package gives you:
  * Type-safe zone-scoped mutability
  * Helpful methods for forking zones

# Getting Started
```yaml
dependencies:
  zone_local: ^0.1.1
```

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