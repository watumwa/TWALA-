enum RideService { boda, car }

extension RideServiceCopy on RideService {
  String get label => this == RideService.boda ? 'Boda-boda' : 'Car';
  String get providerLabel => this == RideService.boda ? 'Rider' : 'Driver';
  String get eta => this == RideService.boda ? '3 min' : '6 min';
  String get seats => this == RideService.boda ? '1 passenger' : 'Up to 4 passengers';
  int get estimate => this == RideService.boda ? 8500 : 18500;
}

enum PaymentMethod { cash, cashless, wallet }

extension PaymentMethodCopy on PaymentMethod {
  String get label => switch (this) {
        PaymentMethod.cash => 'Cash',
        PaymentMethod.cashless => 'Mobile Money',
        PaymentMethod.wallet => 'TWALA Wallet',
      };

  String get detail => switch (this) {
        PaymentMethod.cash => 'Pay your Captain after the trip',
        PaymentMethod.cashless => 'MTN or Airtel Money • Demo',
        PaymentMethod.wallet => 'Available balance: UGX 42,500',
      };
}

enum BookingStage {
  route,
  payment,
  review,
  searching,
  matched,
  arrived,
  inProgress,
  complete,
}

extension BookingStageCopy on BookingStage {
  String get label => switch (this) {
        BookingStage.route => 'Set your route',
        BookingStage.payment => 'Choose payment',
        BookingStage.review => 'Review booking',
        BookingStage.searching => 'Finding a Captain',
        BookingStage.matched => 'Captain on the way',
        BookingStage.arrived => 'Captain has arrived',
        BookingStage.inProgress => 'Trip in progress',
        BookingStage.complete => 'Trip complete',
      };
}

enum CaptainTripStage { offline, ready, request, pickup, arrived, active, completed }

String formatUgx(num amount) {
  final digits = amount.round().toString();
  final output = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    output.write(digits[index]);
    final remaining = digits.length - index - 1;
    if (remaining > 0 && remaining % 3 == 0) output.write(',');
  }
  return 'UGX $output';
}

class DemoCaptain {
  const DemoCaptain({
    required this.name,
    required this.rating,
    required this.trips,
    required this.vehicle,
    required this.registration,
    required this.id,
  });

  final String name;
  final double rating;
  final int trips;
  final String vehicle;
  final String registration;
  final String id;
}

const demoCaptain = DemoCaptain(
  name: 'Mugisa Daniel',
  rating: 4.9,
  trips: 428,
  vehicle: 'TVS HLX • Orange helmet',
  registration: 'UEX 418Q',
  id: 'TW-HOI-0241',
);

