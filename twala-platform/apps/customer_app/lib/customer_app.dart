import 'dart:async';
import 'demo_api.dart';
import 'package:flutter/material.dart';
import 'package:twala_demo_core/twala_demo_core.dart';
import 'package:twala_ui/twala_ui.dart';

class CustomerApp extends StatefulWidget {
  const CustomerApp({super.key});

  @override
  State<CustomerApp> createState() => _CustomerAppState();
}

class _CustomerAppState extends State<CustomerApp> {
  int tab = 0;
  RideService? booking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        const DemoModeBanner(),
        Expanded(
          child: booking == null
              ? IndexedStack(index: tab, children: [
                  HomePage(onBook: (value) => setState(() => booking = value)),
                  const ActivityPage(),
                  const WalletPage(),
                  const AccountPage(),
                ])
              : BookingPage(initialService: booking!, onClose: () => setState(() => booking = null)),
        ),
      ]),
      bottomNavigationBar: booking == null
          ? NavigationBar(
              selectedIndex: tab,
              onDestinationSelected: (value) => setState(() => tab = value),
              backgroundColor: Colors.white,
              indicatorColor: TwalaColors.orangeSoft,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Activity'),
                NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
                NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Account'),
              ],
            )
          : null,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onBook});
  final ValueChanged<RideService> onBook;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
          decoration: const BoxDecoration(color: TwalaColors.deepGreen, borderRadius: BorderRadius.vertical(bottom: Radius.circular(34))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [Expanded(child: TwalaWordmark(light: true, compact: true)), CircleIcon(icon: Icons.notifications_none, dark: true)]),
            const SizedBox(height: 30),
            Text('Good morning, Amina', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color(0xFFC5D9D5))),
            const SizedBox(height: 5),
            Text('Where are we going?', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white)),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
              child: const Row(children: [Icon(Icons.search, color: TwalaColors.orange), SizedBox(width: 12), Expanded(child: Text('Search destination', style: TextStyle(color: TwalaColors.muted, fontSize: 16))), Icon(Icons.arrow_forward)]),
            ),
          ]),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
        sliver: SliverList.list(children: [
          const TwalaSectionHeader(title: 'Choose your ride'),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: RideCard(key: const Key('book-boda'), service: RideService.boda, icon: Icons.two_wheeler, color: TwalaColors.orange, onTap: () => onBook(RideService.boda))),
            const SizedBox(width: 12),
            Expanded(child: RideCard(key: const Key('book-car'), service: RideService.car, icon: Icons.directions_car, color: TwalaColors.teal, onTap: () => onBook(RideService.car))),
          ]),
          const SizedBox(height: 24),
          const TwalaSectionHeader(title: 'Quick ways to book'),
          const SizedBox(height: 12),
          Card(child: Column(children: [
            ActionTile(icon: Icons.tag, title: 'Enter Captain ID', subtitle: 'Pair with a verified Captain nearby', onTap: () => onBook(RideService.boda)),
            const Divider(height: 1, indent: 70),
            ActionTile(icon: Icons.qr_code_scanner, title: 'Scan Captain QR', subtitle: 'Scan approved TWALA identification', onTap: () => onBook(RideService.boda)),
          ])),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(19),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFFE6DA), Color(0xFFFFF7E9)]), borderRadius: BorderRadius.circular(25), border: Border.all(color: const Color(0xFFFFD0B8))),
            child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CircleAvatar(backgroundColor: TwalaColors.orange, foregroundColor: Colors.white, child: Icon(Icons.verified_user_outlined)),
              SizedBox(width: 13),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Your ride. Verified.', style: TextStyle(color: TwalaColors.ink, fontSize: 17, fontWeight: FontWeight.w800)), SizedBox(height: 5), Text('Tracked journeys and verified Captains—designed for Hoima.', style: TextStyle(color: TwalaColors.muted, height: 1.4))])),
            ]),
          ),
        ]),
      ),
    ]);
  }
}

class RideCard extends StatelessWidget {
  const RideCard({super.key, required this.service, required this.icon, required this.color, required this.onTap});
  final RideService service;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        height: 188,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: TwalaColors.line)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 64, height: 64, decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(21)), child: Icon(icon, size: 34, color: color)),
          const Spacer(),
          Text(service.label, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('From ${formatUgx(service.estimate)}', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text('${service.eta} away', style: TextStyle(color: color, fontWeight: FontWeight.w800)),
        ]),
      ),
    );
  }
}

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.initialService, required this.onClose});
  final RideService initialService;
  final VoidCallback onClose;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late RideService service = widget.initialService;
  PaymentMethod payment = PaymentMethod.cash;
  BookingStage stage = BookingStage.route;
  final TwalaDemoApi demoApi = TwalaDemoApi();
  String? sharedBookingId;
  Map<String, dynamic>? sharedBooking;
  Timer? bookingPoll;
  bool cancelled = false;
  String? bookingError;
  bool submitting = false;

  @override
  void dispose() {
    bookingPoll?.cancel();
    demoApi.close();
    super.dispose();
  }

  Future<void> createSharedBooking() async {
    if (submitting) return;
    setState(() { submitting = true; bookingError = null; });
    try {
      final result = await demoApi.createBooking(
        passenger: 'Amina (Demo)',
        pickup: 'Hoima City Mall, Main Street',
        destination: 'Hoima Regional Referral Hospital',
        service: service.name,
        paymentMethod: payment.name,
        fare: service.estimate,
      );
      final bookings = (result['state'] as Map<String, dynamic>)['bookings'] as List<dynamic>;
      if (!mounted) return;
      setState(() {
        sharedBooking = bookings.first as Map<String, dynamic>;
        sharedBookingId = sharedBooking!['id'] as String;
        stage = BookingStage.searching;
        cancelled = false;
      });
      bookingPoll?.cancel();
      bookingPoll = Timer.periodic(const Duration(seconds: 3), (_) => unawaited(refreshSharedBooking(silent: true)));
    } catch (error) {
      if (mounted) setState(() => bookingError = 'Could not reach the TWALA demo server: $error');
    } finally {
      if (mounted) setState(() => submitting = false);
    }
  }

  Future<void> refreshSharedBooking({bool silent = false}) async {
    if (sharedBookingId == null || submitting) return;
    if (!silent) setState(() { submitting = true; bookingError = null; });
    try {
      final result = await demoApi.snapshot();
      final bookings = (result['state'] as Map<String, dynamic>)['bookings'] as List<dynamic>;
      final matches = bookings.cast<Map<String, dynamic>>().where((b) => b['id'] == sharedBookingId);
      if (matches.isEmpty) throw StateError('Booking not found');
      final status = matches.first['status'];
      if (status == 'cancelled' || status == 'completed') bookingPoll?.cancel();
      final nextStage = switch (status) {
        'searching' => BookingStage.searching,
        'matched' => BookingStage.matched,
        'arrived' => BookingStage.arrived,
        'in_progress' => BookingStage.inProgress,
        'completed' => BookingStage.complete,
        _ => BookingStage.searching,
      };
      if (mounted) setState(() {
        sharedBooking = matches.first;
        cancelled = status == 'cancelled';
        stage = nextStage;
      });
    } catch (error) {
      if (!silent && mounted) setState(() => bookingError = 'Could not refresh booking: $error');
    } finally {
      if (!silent && mounted) setState(() => submitting = false);
    }
  }

  void back() {
    if (stage == BookingStage.route || stage.index >= BookingStage.searching.index) { bookingPoll?.cancel(); return widget.onClose(); }
    setState(() => stage = BookingStage.values[stage.index - 1]);
  }

  void next() {
    if (cancelled) { bookingPoll?.cancel(); widget.onClose(); return; }
    if (stage == BookingStage.review) { createSharedBooking(); return; }
    if (sharedBookingId != null && stage.index >= BookingStage.searching.index && stage != BookingStage.complete) { refreshSharedBooking(); return; }
    if (stage == BookingStage.complete) return widget.onClose();
    setState(() => stage = BookingStage.values[stage.index + 1]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 18, 10),
        child: Row(children: [IconButton(onPressed: back, icon: const Icon(Icons.arrow_back)), Expanded(child: Text(stage.label, style: Theme.of(context).textTheme.titleLarge)), const TwalaStatusPill(label: 'Demo', icon: Icons.science_outlined, background: TwalaColors.orangeSoft, foreground: TwalaColors.orangeDark)]),
      ),
      if (stage.index <= BookingStage.review.index)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            children: List.generate(
              3,
              (index) => Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index == 2 ? 0 : 6),
                  decoration: BoxDecoration(
                    color: index <= stage.index ? TwalaColors.orange : TwalaColors.line,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ),
      Expanded(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: switch (stage) {
            BookingStage.route => routeStep(context),
            BookingStage.payment => paymentStep(context),
            BookingStage.review => reviewStep(context),
            BookingStage.searching => statusStep(context),
            BookingStage.matched => statusStep(context),
            BookingStage.arrived => statusStep(context),
            BookingStage.inProgress => statusStep(context),
            BookingStage.complete => receiptStep(context),
          },
        ),
      ),
      if (cancelled) const Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8), child: Text('This demo booking was cancelled.', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
      if (bookingError != null) Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text(bookingError!, style: const TextStyle(color: Colors.red))),
      if (sharedBookingId != null) Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('Shared demo booking: $sharedBookingId')),
      Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 18), child: FilledButton(key: const Key('booking-next'), onPressed: submitting ? null : next, child: Text(cancelled ? 'Close cancelled booking' : submitting ? 'Connecting…' : sharedBookingId != null && stage != BookingStage.complete ? 'Refresh trip status' : buttonLabel))),
    ]);
  }

  String get buttonLabel => switch (stage) {
        BookingStage.route => 'Continue to payment',
        BookingStage.payment => 'Review booking',
        BookingStage.review => 'Confirm and find Captain',
        BookingStage.searching => 'Simulate Captain match',
        BookingStage.matched => 'Simulate Captain arrival',
        BookingStage.arrived => 'Start demo trip',
        BookingStage.inProgress => 'Complete demo trip',
        BookingStage.complete => 'Done',
      };

  Widget routeStep(BuildContext context) => ListView(key: const ValueKey('route'), padding: const EdgeInsets.fromLTRB(20, 20, 20, 10), children: [
        const TwalaMapCanvas(height: 230, showCaptain: false),
        const SizedBox(height: 17),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: const [LocationLine(icon: Icons.my_location, color: TwalaColors.teal, label: 'Pickup', value: 'Hoima City Mall, Main Street'), Padding(padding: EdgeInsets.only(left: 18), child: Divider(height: 24)), LocationLine(icon: Icons.location_on, color: TwalaColors.orange, label: 'Destination', value: 'Hoima Regional Referral Hospital')]))),
        const SizedBox(height: 17),
        SegmentedButton<RideService>(segments: const [ButtonSegment(value: RideService.boda, icon: Icon(Icons.two_wheeler), label: Text('Boda-boda')), ButtonSegment(value: RideService.car, icon: Icon(Icons.directions_car), label: Text('Car'))], selected: {service}, onSelectionChanged: (value) => setState(() => service = value.first), showSelectedIcon: false),
      ]);

  Widget paymentStep(BuildContext context) => ListView(key: const ValueKey('payment'), padding: const EdgeInsets.fromLTRB(20, 22, 20, 10), children: [
        Text('How would you like to pay?', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 7),
        Text('Your choice is attached before matching begins.', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 22),
        for (final method in PaymentMethod.values) Padding(padding: const EdgeInsets.only(bottom: 12), child: PaymentChoice(method: method, selected: payment == method, onTap: () => setState(() => payment = method))),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: TwalaColors.mint, borderRadius: BorderRadius.circular(20)), child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.info_outline, color: TwalaColors.teal), SizedBox(width: 11), Expanded(child: Text('Only Captains eligible for this payment method receive the request.', style: TextStyle(color: TwalaColors.deepGreen, fontWeight: FontWeight.w600, height: 1.4)))])),
      ]);

  Widget reviewStep(BuildContext context) => ListView(key: const ValueKey('review'), padding: const EdgeInsets.fromLTRB(20, 20, 20, 10), children: [
        const TwalaMapCanvas(height: 190, showCaptain: false),
        const SizedBox(height: 17),
        Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [SummaryLine(icon: service == RideService.boda ? Icons.two_wheeler : Icons.directions_car, label: 'Service', value: service.label), const Divider(height: 28), const SummaryLine(icon: Icons.route, label: 'Trip', value: '5.8 km • about 18 min'), const Divider(height: 28), SummaryLine(icon: Icons.payments_outlined, label: 'Payment', value: payment.label), const Divider(height: 28), SummaryLine(icon: Icons.receipt_long_outlined, label: 'Estimated fare', value: formatUgx(service.estimate), strong: true)]))),
        const SizedBox(height: 12),
        Text('Final fare may change with actual time, distance, or an approved destination change.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
      ]);

  Widget statusStep(BuildContext context) {
    if (stage == BookingStage.searching) {
      return ListView(key: const ValueKey('searching'), padding: const EdgeInsets.fromLTRB(20, 24, 20, 10), children: [const TwalaMapCanvas(height: 280, progress: .3), const SizedBox(height: 27), const Center(child: SizedBox(width: 40, height: 40, child: CircularProgressIndicator(color: TwalaColors.orange, strokeWidth: 4))), const SizedBox(height: 17), Text('Finding an eligible ${service.providerLabel}', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 7), Text('Checking verification, distance, availability, and payment eligibility.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium)]);
    }
    if (stage == BookingStage.inProgress) {
      return ListView(key: const ValueKey('trip'), padding: const EdgeInsets.fromLTRB(20, 12, 20, 10), children: [const TwalaMapCanvas(height: 300, progress: .72), const SizedBox(height: 17), Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const TwalaStatusPill(label: 'On trip • tracking simulated', icon: Icons.navigation), const SizedBox(height: 15), Text('12 min to destination', style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 5), Text('Hoima Regional Referral Hospital', style: Theme.of(context).textTheme.bodyLarge), const Divider(height: 28), Row(children: [Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.shield_outlined), label: const Text('Safety'))), const SizedBox(width: 10), Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.ios_share), label: const Text('Share trip')))])])))]);
    }
    final arrived = stage == BookingStage.arrived;
    return ListView(key: ValueKey(stage), padding: const EdgeInsets.fromLTRB(20, 12, 20, 10), children: [
      TwalaMapCanvas(height: 260, progress: arrived ? .9 : .58),
      const SizedBox(height: 16),
      if (arrived && sharedBooking?['pickupVerified'] != true && sharedBooking?['pickupCode'] != null)
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
          const Text('YOUR PICKUP VERIFICATION CODE', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(sharedBooking!['pickupCode'].toString(), style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 6),
          const Text('Share this demo code with your Captain only when you meet at pickup.', textAlign: TextAlign.center),
        ]))),
      if (arrived && sharedBooking?['pickupVerified'] == true)
        const Card(child: Padding(padding: EdgeInsets.all(18), child: Text('Pickup verified. Your Captain can start the demo trip.'))),
      Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [Row(children: [const CircleAvatar(radius: 29, backgroundColor: TwalaColors.orangeSoft, child: Text('MD', style: TextStyle(color: TwalaColors.orangeDark, fontWeight: FontWeight.w900))), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(demoCaptain.name, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 4), Text('${service.providerLabel} • ${demoCaptain.rating} ★ • ${demoCaptain.trips} trips', style: Theme.of(context).textTheme.bodyMedium)])), const CircleIcon(icon: Icons.call_outlined)]), const Divider(height: 28), Row(children: [Icon(service == RideService.boda ? Icons.two_wheeler : Icons.directions_car, color: TwalaColors.teal), const SizedBox(width: 11), Expanded(child: Text(demoCaptain.vehicle, style: const TextStyle(fontWeight: FontWeight.w700))), Text(demoCaptain.registration, style: const TextStyle(fontWeight: FontWeight.w900))]), const SizedBox(height: 14), TwalaStatusPill(label: arrived ? 'Your ${service.providerLabel} has arrived' : '${service.eta} away • ID ${demoCaptain.id}', icon: arrived ? Icons.check_circle_outline : Icons.schedule)]))),
    ]);
  }

  Widget receiptStep(BuildContext context) => ListView(key: const ValueKey('receipt'), padding: const EdgeInsets.fromLTRB(20, 22, 20, 10), children: [
        const Center(child: CircleAvatar(radius: 38, backgroundColor: TwalaColors.mint, child: Icon(Icons.check, size: 40, color: TwalaColors.teal))),
        const SizedBox(height: 15),
        Text('You’ve arrived', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineLarge),
        Text('Demo trip ${sharedBookingId ?? 'unknown'}', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 20),
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [Text(formatUgx((sharedBooking?['fare'] as num?)?.toInt() ?? service.estimate), style: Theme.of(context).textTheme.headlineLarge), const SizedBox(height: 4), Text('Payment selected: ${sharedBooking?['paymentMethod'] ?? payment.name} • simulated, not settled', style: Theme.of(context).textTheme.bodyMedium), const Divider(height: 30), LocationLine(icon: Icons.my_location, color: TwalaColors.teal, label: 'Pickup', value: sharedBooking?['pickup']?.toString() ?? 'Hoima City Mall'), const SizedBox(height: 14), LocationLine(icon: Icons.location_on, color: TwalaColors.orange, label: 'Destination', value: sharedBooking?['destination']?.toString() ?? 'Hoima Regional Referral Hospital')]))),
        const SizedBox(height: 17),
        Text('How was your ${service.providerLabel}?', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.star, color: TwalaColors.warning, size: 34), Icon(Icons.star, color: TwalaColors.warning, size: 34), Icon(Icons.star, color: TwalaColors.warning, size: 34), Icon(Icons.star, color: TwalaColors.warning, size: 34), Icon(Icons.star_border, color: TwalaColors.warning, size: 34)]),
      ]);
}

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});
  @override
  Widget build(BuildContext context) => BasicPage(title: 'Your activity', subtitle: 'Trips and booking updates', child: Column(children: [for (final trip in const [('Boda-boda', 'Hoima City Mall → Kasingo', 'UGX 8,500', Icons.two_wheeler), ('Car', 'Bujumbura Road → Hoima Stadium', 'UGX 21,000', Icons.directions_car), ('Boda-boda', 'Kigorobya Road → Main Street', 'UGX 10,200', Icons.two_wheeler)]) Padding(padding: const EdgeInsets.only(bottom: 10), child: Card(child: ListTile(contentPadding: const EdgeInsets.all(15), leading: CircleAvatar(backgroundColor: TwalaColors.orangeSoft, child: Icon(trip.$4, color: TwalaColors.orangeDark)), title: Text(trip.$1, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text('${trip.$2}\nCompleted • Demo'), isThreeLine: true, trailing: Text(trip.$3, style: const TextStyle(fontWeight: FontWeight.w900)))))]));
}

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});
  @override
  Widget build(BuildContext context) => BasicPage(title: 'TWALA Wallet', subtitle: 'Demo financial view', child: Column(children: [
    Container(width: double.infinity, padding: const EdgeInsets.all(23), decoration: BoxDecoration(gradient: const LinearGradient(colors: [TwalaColors.deepGreen, Color(0xFF26636A)]), borderRadius: BorderRadius.circular(27)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Available balance', style: TextStyle(color: Color(0xFFC9DDDA))), const SizedBox(height: 7), Text('UGX 42,500', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white)), const SizedBox(height: 5), const Text('Fictional prototype funds', style: TextStyle(color: Color(0xFFFFC1A4), fontSize: 12, fontWeight: FontWeight.w700)), const SizedBox(height: 19), Row(children: [Expanded(child: FilledButton(onPressed: () {}, style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: TwalaColors.ink), child: const Text('Deposit'))), const SizedBox(width: 10), Expanded(child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white54)), child: const Text('Withdraw')))])])),
    const SizedBox(height: 18),
    Card(child: Column(children: const [TransactionRow(title: 'Wallet deposit', detail: 'Confirmed • Demo', amount: '+ UGX 30,000', positive: true), Divider(height: 1, indent: 65), TransactionRow(title: 'Boda-boda trip', detail: 'TW-HOI-10028', amount: '− UGX 8,500'), Divider(height: 1, indent: 65), TransactionRow(title: 'Withdrawal', detail: 'Pending • Funds reserved', amount: '− UGX 10,000')]))
  ]));
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) => BasicPage(title: 'Your account', subtitle: 'Passenger profile', child: Column(children: [
    Card(child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [const CircleAvatar(radius: 30, backgroundColor: TwalaColors.orangeSoft, child: Text('AN', style: TextStyle(color: TwalaColors.orangeDark, fontWeight: FontWeight.w900))), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Amina Nabirye', style: Theme.of(context).textTheme.titleLarge), Text('+256 700 000 123', style: Theme.of(context).textTheme.bodyMedium)])), const Icon(Icons.chevron_right)]))),
    const SizedBox(height: 16),
    Card(child: Column(children: const [AccountRow(icon: Icons.shield_outlined, title: 'Safety centre'), Divider(height: 1, indent: 65), AccountRow(icon: Icons.support_agent, title: 'Help and complaints'), Divider(height: 1, indent: 65), AccountRow(icon: Icons.settings_outlined, title: 'Settings and privacy')]))
  ]));
}

class BasicPage extends StatelessWidget {
  const BasicPage({super.key, required this.title, required this.subtitle, required this.child});
  final String title;
  final String subtitle;
  final Widget child;
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(20, 22, 20, 28), children: [Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.headlineMedium), Text(subtitle, style: Theme.of(context).textTheme.bodyMedium)])), const TwalaWordmark(compact: true)]), const SizedBox(height: 22), child]);
}

class ActionTile extends StatelessWidget {
  const ActionTile({super.key, required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ListTile(onTap: onTap, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7), leading: CircleAvatar(backgroundColor: TwalaColors.orangeSoft, child: Icon(icon, color: TwalaColors.orangeDark)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text(subtitle), trailing: const Icon(Icons.arrow_forward));
}

class CircleIcon extends StatelessWidget {
  const CircleIcon({super.key, required this.icon, this.dark = false});
  final IconData icon;
  final bool dark;
  @override
  Widget build(BuildContext context) => Container(width: 42, height: 42, decoration: BoxDecoration(color: dark ? const Color(0xFF2A555A) : TwalaColors.canvas, shape: BoxShape.circle), child: Icon(icon, color: dark ? Colors.white : TwalaColors.ink, size: 21));
}

class LocationLine extends StatelessWidget {
  const LocationLine({super.key, required this.icon, required this.color, required this.label, required this.value});
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: color, size: 22), const SizedBox(width: 11), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label.toUpperCase(), style: const TextStyle(color: TwalaColors.muted, fontSize: 10, letterSpacing: .8, fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(value, style: const TextStyle(color: TwalaColors.ink, fontWeight: FontWeight.w700, height: 1.3))]))]);
}

class PaymentChoice extends StatelessWidget {
  const PaymentChoice({super.key, required this.method, required this.selected, required this.onTap});
  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;
  IconData get icon => switch (method) { PaymentMethod.cash => Icons.payments_outlined, PaymentMethod.cashless => Icons.phone_android, PaymentMethod.wallet => Icons.account_balance_wallet_outlined };
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(22), child: Ink(padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: selected ? TwalaColors.orangeSoft : Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: selected ? TwalaColors.orange : TwalaColors.line, width: selected ? 2 : 1)), child: Row(children: [CircleAvatar(backgroundColor: Colors.white, child: Icon(icon, color: selected ? TwalaColors.orangeDark : TwalaColors.ink)), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(method.label, style: const TextStyle(color: TwalaColors.ink, fontSize: 16, fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(method.detail, style: Theme.of(context).textTheme.bodyMedium)])), Icon(selected ? Icons.check_circle : Icons.circle_outlined, color: selected ? TwalaColors.orange : TwalaColors.line)])));
}

class SummaryLine extends StatelessWidget {
  const SummaryLine({super.key, required this.icon, required this.label, required this.value, this.strong = false});
  final IconData icon;
  final String label;
  final String value;
  final bool strong;
  @override
  Widget build(BuildContext context) => Row(children: [Icon(icon, color: TwalaColors.orangeDark), const SizedBox(width: 12), Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)), Text(value, style: TextStyle(color: TwalaColors.ink, fontSize: strong ? 18 : 14, fontWeight: strong ? FontWeight.w900 : FontWeight.w700))]);
}

class TransactionRow extends StatelessWidget {
  const TransactionRow({super.key, required this.title, required this.detail, required this.amount, this.positive = false});
  final String title;
  final String detail;
  final String amount;
  final bool positive;
  @override
  Widget build(BuildContext context) => ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6), leading: const CircleAvatar(backgroundColor: TwalaColors.canvas, child: Icon(Icons.receipt_long_outlined, color: TwalaColors.ink)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text(detail), trailing: Text(amount, style: TextStyle(color: positive ? TwalaColors.teal : TwalaColors.ink, fontWeight: FontWeight.w900)));
}

class AccountRow extends StatelessWidget {
  const AccountRow({super.key, required this.icon, required this.title});
  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) => ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5), leading: CircleAvatar(backgroundColor: TwalaColors.canvas, child: Icon(icon, color: TwalaColors.ink)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), trailing: const Icon(Icons.chevron_right));
}
