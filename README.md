# Introduction
  * Zone-local values are similar to "ThreadLocal" values in multi-threading languages like Java.
    In terms of performance, creating a new [Zone](https://api.dartlang.org/stable/dart-async/Zone-class.html)
    is much cheaper than creating a thread. See [explanation of zones at dartlang.org](https://www.dartlang.org/articles/libraries/zones).
  * This packages optimizes ease and performance of:
    * Getting a zone-scoped value.
    * Setting the default values. You can optionally prevent accidental mutations of default values.
    * Forking the current zone.
  * A minimalistic alternative to dependency injection.
    * Introduces a single, easy-to-understand class.
    * No compile-time code generation or other magic.

# Example
## pubspec.yaml
```yaml
dependencies:
  zone_local: ^0.1.0
```

## main.dart
```dart
import 'package:zone_local/zone_local.dart';

void main() {
  // Configure a zone-local service.
  // The method also prevents later (accidental) modification of the default value.
  GreetingService.zoneLocal.freezeDefaultValue(GreetingService("Hello, world!"));

  // Use the service
  print(GreetingService.zoneLocal.value.greeting);
  // --> Hello, world!

  // Fork a zone with different value
  final forkedZone = GreetingService.zoneLocal.forkZoneWithValue(new GreetingService("Hi, forked zone!"));
  forkedZone.run(() {
    print(GreetingService.zoneLocal.value.greeting);
    // --> Hi forked, zone!
  });
}

class GreetingService {
  static final ZoneLocal<GreetingService> zoneLocal = ZoneLocal<GreetingService>();

  final String greeting;
  GreetingService(this.greeting);
}
```