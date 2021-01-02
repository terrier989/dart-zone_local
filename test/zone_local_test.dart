import 'package:test/test.dart';
import 'package:zone_local/zone_local.dart';

void main() {
  test('ZoneLocal<String?>(defaultValue: null)', () {
    final a = ZoneLocal<String?>(defaultValue: null);
    expect(a.defaultValue, null);
    expect(a.value, null);
  });

  test("ZoneLocal<String>(defaultValue: 'x')", () {
    final a = ZoneLocal<String>(defaultValue: 'x');
    expect(a.defaultValue, 'x');
    expect(a.value, 'x');
  });

  test('forkZoneWithValue(...)', () {
    final a = ZoneLocal<String>(defaultValue: 'a');

    // Create zone1
    final zone1 = a.forkZoneWithValue('a_zone1');

    // Value inside the initial zone remains the same
    expect(a.value, 'a');

    zone1.run(() {
      // Test value inside zone1
      expect(a.value, 'a_zone1');

      // Create zone2
      final zone2 = a.forkZoneWithValue('a_zone2');

      // Value inside zone1 remains the same
      expect(a.value, 'a_zone1');

      zone2.run(() {
        // Test value inside zone2
        expect(a.value, 'a_zone2');
      });
    });
  });

  test('freezeDefaultValue(...)', () {
    final a = ZoneLocal<String>(defaultValue: 'a');
    final b = ZoneLocal<String>(defaultValue: 'b');
    a.freezeDefaultValue('a_frozen');
    expect(a.value, 'a_frozen');
    expect(b.value, 'b');

    // Mutating 'a' defaultValue should fail
    expect(
      () => a.defaultValue = 'fails',
      throwsA(const TypeMatcher<StateError>()),
    );

    // Mutate 'b'
    b.defaultValue = 'b_mutated';
    expect(b.defaultValue, 'b_mutated');
  });
}
