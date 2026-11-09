import 'dart:math' as math;

import 'package:flutter/material.dart';

abstract final class TwalaColors {
  // Legacy aliases retained for existing widgets; all now use TWALA's African palette.
  static const green = Color(0xFF189E4B);
  static const gold = Color(0xFFD4A017);
  static const red = Color(0xFFD62828);
  static const black = Color(0xFF171717);
  static const orange = green;
  static const orangeDark = Color(0xFF117A39);
  static const orangeSoft = Color(0xFFE9F7EE);
  static const ink = Color(0xFF171717);
  static const deepGreen = Color(0xFF151515);
  static const teal = Color(0xFF168544);
  static const mint = Color(0xFFE8F6ED);
  static const canvas = Color(0xFFF7F8F5);
  static const surface = Color(0xFFFFFFFF);
  static const line = Color(0xFFE1E6DF);
  static const muted = Color(0xFF656B65);
  static const warning = Color(0xFFD4A017);
  static const danger = Color(0xFFD62828);
}

ThemeData buildTwalaTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: TwalaColors.orange,
    brightness: Brightness.light,
    primary: TwalaColors.orange,
    secondary: TwalaColors.teal,
    surface: TwalaColors.surface,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: TwalaColors.canvas,
    fontFamily: 'sans-serif',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: TwalaColors.ink,
        fontSize: 34,
        height: 1.08,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
      ),
      headlineMedium: TextStyle(
        color: TwalaColors.ink,
        fontSize: 26,
        height: 1.15,
        fontWeight: FontWeight.w800,
        letterSpacing: -.7,
      ),
      titleLarge: TextStyle(
        color: TwalaColors.ink,
        fontSize: 20,
        height: 1.2,
        fontWeight: FontWeight.w750,
      ),
      titleMedium: TextStyle(
        color: TwalaColors.ink,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(color: TwalaColors.ink, fontSize: 16, height: 1.45),
      bodyMedium: TextStyle(color: TwalaColors.muted, fontSize: 14, height: 1.4),
    ),
    cardTheme: const CardThemeData(
      color: TwalaColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        side: BorderSide(color: TwalaColors.line),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: TwalaColors.surface,
      contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        borderSide: BorderSide(color: TwalaColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        borderSide: BorderSide(color: TwalaColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        borderSide: BorderSide(color: TwalaColors.orange, width: 2),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        backgroundColor: TwalaColors.orange,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        foregroundColor: TwalaColors.ink,
        side: const BorderSide(color: TwalaColors.line),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
  );
}

class TwalaWordmark extends StatelessWidget {
  const TwalaWordmark({super.key, this.light = false, this.compact = false});

  final bool light;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final textColor = light ? Colors.white : TwalaColors.ink;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 34 : 42,
          height: compact ? 34 : 42,
          decoration: BoxDecoration(
            color: TwalaColors.orange,
            borderRadius: BorderRadius.circular(compact ? 12 : 15),
            boxShadow: const [
              BoxShadow(color: Color(0x38189E4B), blurRadius: 18, offset: Offset(0, 7)),
            ],
          ),
          child: const Icon(Icons.route_rounded, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Text(
          'TWALA',
          style: TextStyle(
            color: textColor,
            fontSize: compact ? 20 : 24,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.3,
          ),
        ),
      ],
    );
  }
}

class DemoModeBanner extends StatelessWidget {
  const DemoModeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: TwalaColors.ink,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: const SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.science_outlined, size: 15, color: Color(0xFFEAC56B)),
            SizedBox(width: 7),
            Flexible(
              child: Text(
                'DEMO MODE  •  No real rides or payments',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .55,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TwalaStatusPill extends StatelessWidget {
  const TwalaStatusPill({
    super.key,
    required this.label,
    this.icon,
    this.background = TwalaColors.mint,
    this.foreground = TwalaColors.teal,
  });

  final String label;
  final IconData? icon;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: foreground),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(color: foreground, fontSize: 12, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class TwalaSectionHeader extends StatelessWidget {
  const TwalaSectionHeader({super.key, required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        if (action != null)
          TextButton(onPressed: onAction, child: Text(action!, style: const TextStyle(fontWeight: FontWeight.w800))),
      ],
    );
  }
}

class TwalaMapCanvas extends StatelessWidget {
  const TwalaMapCanvas({
    super.key,
    this.height = 220,
    this.showCaptain = true,
    this.progress = .55,
  });

  final double height;
  final bool showCaptain;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: _DemoMapPainter(showCaptain: showCaptain, progress: progress),
          child: Stack(
            children: [
              const Positioned(
                top: 16,
                left: 16,
                child: TwalaStatusPill(
                  label: 'Hoima City • simulated route',
                  icon: Icons.location_on_outlined,
                  background: Colors.white,
                  foreground: TwalaColors.ink,
                ),
              ),
              Positioned(
                right: 14,
                bottom: 14,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.my_location_rounded, color: TwalaColors.ink, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoMapPainter extends CustomPainter {
  const _DemoMapPainter({required this.showCaptain, required this.progress});

  final bool showCaptain;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFE8EEE9));
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 11
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final minorRoad = Paint()
      ..color = const Color(0xFFD8E1DC)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < 6; i++) {
      final y = size.height * (.18 + i * .14);
      canvas.drawLine(Offset(-10, y), Offset(size.width + 10, y - 32), minorRoad);
    }
    for (var i = 0; i < 5; i++) {
      final x = size.width * (.1 + i * .22);
      canvas.drawLine(Offset(x, -10), Offset(x + 58, size.height + 10), minorRoad);
    }
    final route = Path()
      ..moveTo(size.width * .16, size.height * .76)
      ..cubicTo(
        size.width * .34,
        size.height * .65,
        size.width * .43,
        size.height * .30,
        size.width * .79,
        size.height * .23,
      );
    canvas.drawPath(route, roadPaint);
    canvas.drawPath(
      route,
      Paint()
        ..color = TwalaColors.orange
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    _pin(canvas, Offset(size.width * .16, size.height * .76), TwalaColors.ink, false);
    _pin(canvas, Offset(size.width * .79, size.height * .23), TwalaColors.orange, true);
    if (showCaptain) {
      final t = progress.clamp(0.0, 1.0);
      final point = _bezier(
        Offset(size.width * .16, size.height * .76),
        Offset(size.width * .34, size.height * .65),
        Offset(size.width * .43, size.height * .30),
        Offset(size.width * .79, size.height * .23),
        t,
      );
      canvas.drawCircle(point, 14, Paint()..color = Colors.white);
      canvas.drawCircle(point, 10, Paint()..color = TwalaColors.teal);
      final bike = TextPainter(
        text: const TextSpan(text: '●', style: TextStyle(color: Colors.white, fontSize: 9)),
        textDirection: TextDirection.ltr,
      )..layout();
      bike.paint(canvas, point - Offset(bike.width / 2, bike.height / 2));
    }
  }

  Offset _bezier(Offset a, Offset b, Offset c, Offset d, double t) {
    final mt = 1 - t;
    return Offset(
      math.pow(mt, 3) * a.dx + 3 * math.pow(mt, 2) * t * b.dx + 3 * mt * math.pow(t, 2) * c.dx + math.pow(t, 3) * d.dx,
      math.pow(mt, 3) * a.dy + 3 * math.pow(mt, 2) * t * b.dy + 3 * mt * math.pow(t, 2) * c.dy + math.pow(t, 3) * d.dy,
    );
  }

  void _pin(Canvas canvas, Offset center, Color color, bool destination) {
    canvas.drawCircle(center, 11, Paint()..color = Colors.white);
    canvas.drawCircle(center, 7, Paint()..color = color);
    if (!destination) canvas.drawCircle(center, 2.5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _DemoMapPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.showCaptain != showCaptain;
}

class MobilePrototypeFrame extends StatelessWidget {
  const MobilePrototypeFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFDCE4DF),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 470),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: TwalaColors.canvas,
              boxShadow: [BoxShadow(color: Color(0x24000000), blurRadius: 32)],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

