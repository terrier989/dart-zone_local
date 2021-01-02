import 'package:zone_local/zone_local.dart';
import 'dart:async';

final ZoneLocal<String> greeting = ZoneLocal<String>(defaultValue: 'Hello!');

void main() {
  print('In the default zone: ${greeting.value}');

  // Run a function in a forked zone that sees value "Hi!"
  final forkedZone = Zone.current.fork(zoneValues: {
    greeting.key: 'Hello',
  });

  forkedZone.run(() {
    print('In the forked zone: ${greeting.value}');
  });
  print('In the default zone: ${greeting.value}');
}