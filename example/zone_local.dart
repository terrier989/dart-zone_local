import 'package:zone_local/zone_local.dart';

final ZoneLocal<String> greeting = new ZoneLocal<String>(defaultValue:"Hello!");

void main() {
  print(greeting.value);

  // Run a function in a forked zone that sees value "Hi!"
  greeting.forkZoneWithValue("Hi!").run(() {
    print(greeting.value);
  });
}