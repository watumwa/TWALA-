import 'package:flutter/material.dart';
import 'package:twala_ui/twala_ui.dart';

import 'customer_app.dart';

void main() => runApp(const TwalaCustomerPrototype());

class TwalaCustomerPrototype extends StatelessWidget {
  const TwalaCustomerPrototype({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TWALA Customer • Demo',
      theme: buildTwalaTheme(),
      home: const MobilePrototypeFrame(child: CustomerApp()),
    );
  }
}
