import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final Widget bnb;
  final Widget child;

  const MainLayout({super.key, required this.bnb, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: bnb,
            ),
          ),
        ],
      ),
    );
  }
}
