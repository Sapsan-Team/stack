import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final Widget bnb;
  final Widget child;

  const MainLayout({super.key, required this.bnb, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [bnb],
      ),
    );
  }
}
