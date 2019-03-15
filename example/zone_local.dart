import 'package:zone_local/zone_local.dart';

void main() {
  // Configure a zone-local service.
  // The method also prevents later (accidental) modification of the default value.
  GreetingService.zoneLocal
      .freezeDefaultValue(GreetingService("Hello, world!"));

  // Use the service
  print(GreetingService.zoneLocal.value.greeting);
  // --> Hello, world!

  // Fork a zone with different value
  final forkedZone = GreetingService.zoneLocal
      .forkZoneWithValue(GreetingService("Hi, forked zone!"));
  forkedZone.run(() {
    print(GreetingService.zoneLocal.value.greeting);
    // --> Hi forked, zone!
  });
}

class GreetingService {
  static final ZoneLocal<GreetingService> zoneLocal =
      ZoneLocal<GreetingService>();

  final String greeting;
  GreetingService(this.greeting);
}
