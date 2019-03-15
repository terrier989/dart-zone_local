import 'dart:async';

import 'package:test/test.dart';
import 'package:zone_local/zone_local.dart';

void main() {
  test("Zone()", () {
    final a = ZoneLocal<String>();
    expect(a.isDefaultValueFrozen, false);
    expect(a.defaultValue, null);
    expect(a.value, null);
  });

  test("Zone(defaultValue: 'x')", () {
    final a = ZoneLocal<String>(defaultValue: 'x');
    expect(a.isDefaultValueFrozen, false);
    expect(a.defaultValue, "x");
    expect(a.value, "x");
  });

  test("forkZoneWithValue(...)", () {
    final a = ZoneLocal<String>(defaultValue: "a");

    // Create zone1
    final zone1 = a.forkZoneWithValue("a_zone1");

    // Value inside the initial zone remains the same
    expect(a.value, "a");

    zone1.run(() {
      // Test value inside zone1
      expect(a.value, "a_zone1");

      // Create zone2
      final zone2 = a.forkZoneWithValue("a_zone2");

      // Value inside zone1 remains the same
      expect(a.value, "a_zone1");

      zone2.run(() {
        // Test value inside zone2
        expect(a.value, "a_zone2");
      });
    });
  });

  test("forkZoneWithValues(...)", () {
    final a = ZoneLocal<String>(defaultValue: "a");
    final b = ZoneLocal<String>(defaultValue: "b");
    final c = ZoneLocal<String>(defaultValue: "c");

    // Create zone1
    final zone1 = ZoneLocal.forkZoneWithValues({
      a: "a_zone1",
      b: "b_zone1",
      c: "c_zone1",
    });

    // Values inside the initial zone remain the same
    expect(a.value, "a");
    expect(b.value, "b");
    expect(c.value, "c");

    zone1.run(() {
      // Test values inside zone1
      expect(a.value, "a_zone1");
      expect(b.value, "b_zone1");
      expect(c.value, "c_zone1");

      // Create zone2
      final zone2 = ZoneLocal.forkZoneWithValues({
        b: "b_zone2",
      });

      // Values inside zone1 remain the same
      expect(a.value, "a_zone1");
      expect(b.value, "b_zone1");
      expect(c.value, "c_zone1");

      zone2.run(() {
        // Test values inside zone2
        expect(a.value, "a_zone1");
        expect(b.value, "b_zone2");
        expect(c.value, "c_zone1");
      });
    });
  });

  test("freezeDefaultValue(...)", () {
    final a = ZoneLocal<String>(defaultValue: "a");
    final b = ZoneLocal<String>(defaultValue: "b");

    // Test 'a' and 'b'
    expect(a.isDefaultValueFrozen, isFalse);
    expect(b.isDefaultValueFrozen, isFalse);

    // Freeze
    a.freezeDefaultValue("a_frozen");
    expect(a.isDefaultValueFrozen, isTrue);
    expect(b.isDefaultValueFrozen, isFalse);
    expect(a.value, "a_frozen");
    expect(b.value, "b");

    // Mutating 'a' defaultValue should fail
    expect(() => a.defaultValue = "fails",
        throwsA(const TypeMatcher<StateError>()));

    // Mutate 'b'
    b.defaultValue = "b_mutated";
    expect(b.defaultValue, "b_mutated");
  });

  test("freezeDefaultValues(...)", () {
    final a = ZoneLocal<String>(defaultValue: "a");
    final b = ZoneLocal<String>(defaultValue: "b");
    ZoneLocal.freezeDefaultValues();
    expect(a.isDefaultValueFrozen, isTrue);
    expect(b.isDefaultValueFrozen, isTrue);
    expect(a.defaultValue, "a");
    expect(b.defaultValue, "b");
    expect(a.value, "a");
    expect(b.value, "b");
    expect(() => a.defaultValue = "fails",
        throwsA(const TypeMatcher<StateError>()));
    expect(() => b.defaultValue = "fails",
        throwsA(const TypeMatcher<StateError>()));
  });
}
