import 'package:flutter_test/flutter_test.dart';
import 'package:twala_demo_core/twala_demo_core.dart';

void main() {
  test('service labels distinguish boda riders from car drivers', () {
    expect(RideService.boda.providerLabel, 'Rider');
    expect(RideService.car.providerLabel, 'Driver');
  });

  test('payment choice is a distinct step before Captain search', () {
    expect(BookingStage.values.indexOf(BookingStage.payment),
        lessThan(BookingStage.values.indexOf(BookingStage.searching)));
  });

  test('demo captain has a TWALA identifier', () {
    expect(demoCaptain.id, startsWith('TW-HOI-'));
  });

  test('fare formatter displays UGX thousands separators', () {
    expect(formatUgx(18500), 'UGX 18,500');
  });
}
