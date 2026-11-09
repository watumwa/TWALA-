import 'dart:async';

import 'package:flutter/material.dart';
import 'captain_demo_api.dart';
import 'package:twala_demo_core/twala_demo_core.dart';
import 'package:twala_ui/twala_ui.dart';

class CaptainApp extends StatefulWidget {
  const CaptainApp({super.key});

  @override
  State<CaptainApp> createState() => _CaptainAppState();
}

class _CaptainAppState extends State<CaptainApp> {
  static const captainId = 'TW-HOI-0241';
  final api = const CaptainDemoApi();
  Timer? refreshTimer;
  int tab = 0;
  bool online = false;
  bool busy = false;
  String? error;
  Map<String, dynamic>? activeBooking;
  Map<String, dynamic>? captain;
  List<Map<String, dynamic>> captainBookings = [];
  List<Map<String, dynamic>> captainTransactions = [];
  CaptainTripStage stage = CaptainTripStage.offline;

  @override
  void initState() {
    super.initState();
    unawaited(refresh());
    refreshTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => unawaited(refresh()),
    );
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> refresh() async {
    try {
      final payload = await api.getState();
      if (!mounted) return;
      final state = payload['state'] as Map<String, dynamic>;
      final captains = (state['captains'] as List).cast<Map<String, dynamic>>();
      final bookings = (state['bookings'] as List).cast<Map<String, dynamic>>();
      final transactions = (state['transactions'] as List).cast<Map<String, dynamic>>();
      final currentCaptain = captains.where((c) => c['id'] == captainId).firstOrNull;
      final assigned = bookings.where((b) =>
        b['captainId'] == captainId &&
        ['matched', 'arrived', 'in_progress'].contains(b['status'])).firstOrNull;
      final available = bookings.where((b) =>
        b['status'] == 'searching' &&
        b['service'] == 'boda' &&
        (b['pairing'] == 'standard' || b['requestedCaptainId'] == captainId) &&
        (b['paymentMethod'] == 'cash'
          ? currentCaptain?['cashEligible'] == true
          : currentCaptain?['cashlessEligible'] == true)).firstOrNull;
      final booking = assigned ?? (currentCaptain?['online'] == true && currentCaptain?['status'] == 'verified'
        ? available : null);
      setState(() {
        captain = currentCaptain;
        captainBookings = bookings.where((b) => b['captainId'] == captainId).toList();
        captainTransactions = transactions.where((t) => t['captainId'] == captainId).toList();
        online = currentCaptain?['online'] == true;
        activeBooking = booking;
        error = null;
        if (booking == null) {
          stage = currentCaptain?['online'] == true ? CaptainTripStage.request : CaptainTripStage.offline;
        } else {
          stage = switch (booking['status']) {
            'matched' => CaptainTripStage.pickup,
            'arrived' => CaptainTripStage.arrived,
            'in_progress' => CaptainTripStage.active,
            _ => CaptainTripStage.request,
          };
        }
      });
    } catch (e) {
      if (mounted) setState(() => error = 'Demo API unavailable: $e');
    }
  }

  void setOnline(bool value) {
    unawaited(_setOnline(value));
  }

  Future<void> _setOnline(bool value) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await api.action({
        'action': 'set_captain_online',
        'captainId': captainId,
        'online': value,
      });
      await refresh();
    } catch (e) {
      if (mounted) setState(() => error = 'Availability update failed: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> advance() async {
    final booking = activeBooking;
    if (booking == null || busy || !online) return;
    final status = booking['status']?.toString();
    if (status != 'searching' &&
        status != 'matched' &&
        status != 'arrived' &&
        status != 'in_progress') return;
    setState(() => busy = true);
    try {
      await api.action({
        'action': status == 'searching' ? 'accept_booking' : 'advance_booking',
        'bookingId': booking['id'],
        if (status == 'searching') 'captainId': captainId,
      });
      await refresh();
    } catch (e) {
      if (mounted) setState(() => error = 'Trip action failed: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        const DemoModeBanner(),
        if (error != null)
          MaterialBanner(
            content: Text(error!),
            actions: [TextButton(onPressed: refresh, child: const Text('Retry'))],
          ),
        Expanded(child: IndexedStack(index: tab, children: [
          CaptainHome(
            online: online,
            stage: stage,
            booking: activeBooking,
            busy: busy,
            onOnlineChanged: busy ? (_) {} : setOnline,
            onAdvance: () => unawaited(advance()),
          ),
          EarningsPage(captain: captain, transactions: captainTransactions),
          TripsPage(bookings: captainBookings),
          const CaptainAccountPage(),
        ])),
      ]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        backgroundColor: Colors.white,
        indicatorColor: TwalaColors.mint,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.space_dashboard_outlined), selectedIcon: Icon(Icons.space_dashboard), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.trending_up_outlined), selectedIcon: Icon(Icons.trending_up), label: 'Earnings'),
          NavigationDestination(icon: Icon(Icons.route_outlined), selectedIcon: Icon(Icons.route), label: 'Trips'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}

class CaptainHome extends StatelessWidget {
  const CaptainHome({super.key, required this.online, required this.stage, required this.onOnlineChanged, required this.onAdvance, required this.booking, required this.busy});
  final Map<String, dynamic>? booking;
  final bool busy;
  final bool online;
  final CaptainTripStage stage;
  final ValueChanged<bool> onOnlineChanged;
  final VoidCallback onAdvance;

  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.zero, children: [
      Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
        decoration: const BoxDecoration(color: TwalaColors.deepGreen, borderRadius: BorderRadius.vertical(bottom: Radius.circular(34))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Expanded(child: TwalaWordmark(light: true, compact: true)), TwalaStatusPill(label: 'CAPTAIN APP', background: Color(0xFF29575B), foreground: Colors.white)]),
          const SizedBox(height: 27),
          Row(children: [
            const CircleAvatar(radius: 30, backgroundColor: TwalaColors.orange, child: Text('MD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
            const SizedBox(width: 13),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Mugisa Daniel', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)), const SizedBox(height: 4), const Text('Boda Captain • TW-HOI-0241', style: TextStyle(color: Color(0xFFC5D9D5)))])),
            Switch(value: online, onChanged: onOnlineChanged, activeThumbColor: Colors.white, activeTrackColor: TwalaColors.teal),
          ]),
          const SizedBox(height: 17),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(color: online ? const Color(0xFF245F5A) : const Color(0xFF2A4E53), borderRadius: BorderRadius.circular(18)),
            child: Row(children: [Icon(online ? Icons.radio_button_checked : Icons.pause_circle_outline, color: online ? const Color(0xFF8DE3C9) : Colors.white70), const SizedBox(width: 10), Expanded(child: Text(online ? 'You are online • Demo location active' : 'You are offline • Go online for requests', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))]),
          ),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Expanded(child: StatCard(label: 'Today', value: 'UGX 48,600', detail: '6 completed trips', color: TwalaColors.orange)), const SizedBox(width: 11), const Expanded(child: StatCard(label: 'Rating', value: '4.9 ★', detail: '428 total trips', color: TwalaColors.teal))]),
          const SizedBox(height: 16),
          EligibilityCard(online: online),
          const SizedBox(height: 20),
          TwalaSectionHeader(title: online ? tripTitle(stage) : 'Ready when you are'),
          const SizedBox(height: 12),
          if (!online) OfflineCard(onGoOnline: () => onOnlineChanged(true)) else if (booking == null) const Card(child: Padding(padding: EdgeInsets.all(22), child: Text('Waiting for an eligible booking from the shared TWALA demo API…'))) else TripControl(stage: stage, onAdvance: onAdvance, booking: booking!, busy: busy),
        ]),
      ),
    ]);
  }
}

String tripTitle(CaptainTripStage stage) => switch (stage) {
      CaptainTripStage.request => 'New ride request',
      CaptainTripStage.pickup => 'Navigate to Passenger',
      CaptainTripStage.arrived => 'At the pickup',
      CaptainTripStage.active => 'Trip in progress',
      CaptainTripStage.completed => 'Trip completed',
      _ => 'Current trip',
    };

class TripControl extends StatelessWidget {
  const TripControl({super.key, required this.stage, required this.onAdvance, required this.booking, required this.busy});
  final Map<String, dynamic> booking;
  final bool busy;
  final CaptainTripStage stage;
  final VoidCallback onAdvance;

  @override
  Widget build(BuildContext context) {
    final active = stage == CaptainTripStage.active;
    final completed = stage == CaptainTripStage.completed;
    return Column(children: [
      if (stage != CaptainTripStage.request && !completed) TwalaMapCanvas(height: active ? 245 : 210, progress: active ? .7 : .25),
      if (stage != CaptainTripStage.request && !completed) const SizedBox(height: 13),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: completed ? completedContent(context) : requestContent(context),
        ),
      ),
    ]);
  }

  Widget requestContent(BuildContext context) {
    final request = stage == CaptainTripStage.request;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (request) ...[
        Row(children: [const TwalaStatusPill(label: '18 sec to respond', icon: Icons.timer_outlined, background: TwalaColors.orangeSoft, foreground: TwalaColors.orangeDark), const Spacer(), Text(formatUgx((booking['fare'] as num).toInt()), style: Theme.of(context).textTheme.titleLarge)]),
        const SizedBox(height: 18),
      ],
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.my_location, color: TwalaColors.teal), const SizedBox(width: 11), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('PICKUP', style: TextStyle(color: TwalaColors.muted, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: .8)), const SizedBox(height: 3), Text(booking['pickup'].toString(), style: Theme.of(context).textTheme.titleMedium), Text('Passenger: ${booking['passenger']} • Demo')]))]),
      const Padding(padding: EdgeInsets.only(left: 11), child: SizedBox(height: 24, child: VerticalDivider(color: TwalaColors.line, thickness: 2))),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.location_on, color: TwalaColors.orange), const SizedBox(width: 11), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('DESTINATION', style: TextStyle(color: TwalaColors.muted, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: .8)), const SizedBox(height: 3), Text(booking['destination'].toString(), style: Theme.of(context).textTheme.titleMedium), Text('Payment: ${booking['paymentMethod']} • Demo')]))]),
      const SizedBox(height: 18),
      if (request)
        Row(children: [Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Reject'))), const SizedBox(width: 10), Expanded(flex: 2, child: FilledButton(key: const Key('captain-advance'), onPressed: busy ? null : onAdvance, child: const Text('Accept ride')))])
      else
        FilledButton(key: const Key('captain-advance'), onPressed: busy ? null : onAdvance, child: Text(switch (stage) { CaptainTripStage.pickup => 'I have arrived', CaptainTripStage.arrived => 'Verify and start trip', CaptainTripStage.active => 'Complete demo trip', _ => 'Continue' })),
    ]);
  }

  Widget completedContent(BuildContext context) => Column(children: [
    const CircleAvatar(radius: 30, backgroundColor: TwalaColors.mint, child: Icon(Icons.check, size: 32, color: TwalaColors.teal)),
    const SizedBox(height: 12),
    Text('Trip recorded', style: Theme.of(context).textTheme.headlineMedium),
    const SizedBox(height: 4),
    Text('Demo trip TW-HOI-10028', style: Theme.of(context).textTheme.bodyMedium),
    const Divider(height: 28),
    const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Gross fare'), Text('UGX 8,500', style: TextStyle(fontWeight: FontWeight.w800))]),
    const SizedBox(height: 9),
    const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('TWALA commission (10%)'), Text('UGX 850', style: TextStyle(fontWeight: FontWeight.w800))]),
    const SizedBox(height: 9),
    const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Your share'), Text('UGX 7,650', style: TextStyle(color: TwalaColors.teal, fontWeight: FontWeight.w900))]),
    const SizedBox(height: 18),
    FilledButton(onPressed: onAdvance, child: const Text('Simulate next request')),
  ]);
}

class OfflineCard extends StatelessWidget {
  const OfflineCard({super.key, required this.onGoOnline});
  final VoidCallback onGoOnline;
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const CircleAvatar(radius: 32, backgroundColor: TwalaColors.canvas, child: Icon(Icons.two_wheeler, color: TwalaColors.ink, size: 32)), const SizedBox(height: 13), Text('No ride requests while offline', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 6), Text('Go online when you are ready to receive eligible bookings.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 17), FilledButton(onPressed: onGoOnline, child: const Text('Go online'))])));
}

class EligibilityCard extends StatelessWidget {
  const EligibilityCard({super.key, required this.online});
  final bool online;
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(17), child: Row(children: [const CircleAvatar(backgroundColor: TwalaColors.mint, child: Icon(Icons.verified_outlined, color: TwalaColors.teal)), const SizedBox(width: 12), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Booking eligibility', style: TextStyle(color: TwalaColors.ink, fontWeight: FontWeight.w800)), SizedBox(height: 3), Text('Cash eligible • Cashless eligible', style: TextStyle(color: TwalaColors.muted))])), TwalaStatusPill(label: online ? 'Active' : 'Eligible', icon: Icons.check_circle_outline)])));
}

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.label, required this.value, required this.detail, required this.color});
  final String label;
  final String value;
  final String detail;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: TwalaColors.line)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 7), Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(detail, style: const TextStyle(color: TwalaColors.muted, fontSize: 12))]));
}

class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key, required this.captain, required this.transactions});
  final Map<String, dynamic>? captain;
  final List<Map<String, dynamic>> transactions;

  @override
  Widget build(BuildContext context) {
    final balance = (captain?['walletAvailable'] as num?)?.toInt() ?? 0;
    final commission = (captain?['outstandingCommission'] as num?)?.toInt() ?? 0;
    final pending = transactions.where((t) =>
      t['kind'] == 'withdrawal' && t['status'] == 'pending').fold<int>(
        0, (total, t) => total + ((t['amount'] as num?)?.toInt() ?? 0));
    return CaptainBasicPage(
      title: 'Your earnings',
      subtitle: 'Shared demonstration balances • Not real money',
      child: Column(children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: TwalaColors.deepGreen,
            borderRadius: BorderRadius.circular(27),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Available demo wallet', style: TextStyle(color: Color(0xFFC7DBD7))),
            const SizedBox(height: 7),
            Text(formatUgx(balance), style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white)),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: FinanceMetric(label: 'Pending withdrawals', value: formatUgx(pending))),
              const SizedBox(width: 10),
              Expanded(child: FinanceMetric(label: 'Commission owed', value: formatUgx(commission))),
            ]),
          ]),
        ),
        const SizedBox(height: 18),
        if (transactions.isEmpty)
          const Card(child: Padding(
            padding: EdgeInsets.all(20),
            child: Text('No demo transactions recorded yet.'),
          ))
        else
          Card(child: Column(children: [
            for (final t in transactions.reversed) ...[
              MoneyRow(
                title: '${t['kind']} • ${t['reference']}',
                detail: '${t['status']} • Demo',
                amount: formatUgx((t['amount'] as num).toInt()),
              ),
              const Divider(height: 1, indent: 65),
            ],
          ])),
      ]),
    );
  }
}

class TripsPage extends StatelessWidget {
  const TripsPage({super.key, required this.bookings});
  final List<Map<String, dynamic>> bookings;

  @override
  Widget build(BuildContext context) => CaptainBasicPage(
    title: 'Trip history',
    subtitle: 'Your assigned rides • Shared demo data',
    child: Column(children: [
      if (bookings.isEmpty)
        const Card(child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('No assigned trips yet. Accept a demo booking to begin.'),
        )),
      for (final trip in bookings)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Card(child: ListTile(
            contentPadding: const EdgeInsets.all(15),
            leading: const CircleAvatar(
              backgroundColor: TwalaColors.mint,
              child: Icon(Icons.route, color: TwalaColors.teal),
            ),
            title: Text(
              '${trip['pickup']} → ${trip['destination']}',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text('${trip['id']} • ${trip['paymentMethod']} • ${trip['status']}'),
            trailing: Text(
              formatUgx((trip['fare'] as num).toInt()),
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          )),
        ),
    ]),
  );
}

class CaptainAccountPage extends StatelessWidget {
  const CaptainAccountPage({super.key});
  @override
  Widget build(BuildContext context) => CaptainBasicPage(title: 'Captain account', subtitle: 'Verified provider profile', child: Column(children: [
    Card(child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [const CircleAvatar(radius: 30, backgroundColor: TwalaColors.orangeSoft, child: Text('MD', style: TextStyle(color: TwalaColors.orangeDark, fontWeight: FontWeight.w900))), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Mugisa Daniel', style: Theme.of(context).textTheme.titleLarge), const Text('Approved • Boda Captain', style: TextStyle(color: TwalaColors.teal, fontWeight: FontWeight.w700))])), const Icon(Icons.chevron_right)]))),
    const SizedBox(height: 16),
    Card(child: Column(children: const [CaptainAccountRow(icon: Icons.badge_outlined, title: 'Verification and documents'), Divider(height: 1, indent: 65), CaptainAccountRow(icon: Icons.two_wheeler, title: 'Vehicle information'), Divider(height: 1, indent: 65), CaptainAccountRow(icon: Icons.support_agent, title: 'Captain support'), Divider(height: 1, indent: 65), CaptainAccountRow(icon: Icons.settings_outlined, title: 'Settings and privacy')]))
  ]));
}

class CaptainBasicPage extends StatelessWidget {
  const CaptainBasicPage({super.key, required this.title, required this.subtitle, required this.child});
  final String title;
  final String subtitle;
  final Widget child;
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(20, 22, 20, 28), children: [Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.headlineMedium), Text(subtitle, style: Theme.of(context).textTheme.bodyMedium)])), const TwalaWordmark(compact: true)]), const SizedBox(height: 22), child]);
}

class FinanceMetric extends StatelessWidget {
  const FinanceMetric({super.key, required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF28575C), borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Color(0xFFC7DBD7), fontSize: 11)), const SizedBox(height: 5), Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800))]));
}

class MoneyRow extends StatelessWidget {
  const MoneyRow({super.key, required this.title, required this.detail, required this.amount});
  final String title;
  final String detail;
  final String amount;
  @override
  Widget build(BuildContext context) => ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6), leading: const CircleAvatar(backgroundColor: TwalaColors.canvas, child: Icon(Icons.receipt_long, color: TwalaColors.ink)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text(detail), trailing: Text(amount, style: const TextStyle(fontWeight: FontWeight.w900)));
}

class CaptainAccountRow extends StatelessWidget {
  const CaptainAccountRow({super.key, required this.icon, required this.title});
  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) => ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5), leading: CircleAvatar(backgroundColor: TwalaColors.canvas, child: Icon(icon, color: TwalaColors.ink)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), trailing: const Icon(Icons.chevron_right));
}

