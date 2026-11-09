import 'package:flutter/material.dart';
import 'package:twala_ui/twala_ui.dart';

import 'captain_app.dart';

void main() => runApp(const TwalaCaptainPrototype());

class TwalaCaptainPrototype extends StatelessWidget {
  const TwalaCaptainPrototype({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TWALA Captain • Demo',
      theme: buildTwalaTheme(),
      home: const MobilePrototypeFrame(child: CaptainApp()),
    );
  }
}
