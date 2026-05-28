import 'package:flutter/material.dart';

/// Placeholder home screen — Sprint 2 will replace this with the match list.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kickoff Buddy'),
      ),
      body: const Center(
        child: Text('Sprint 2 will land match list here'),
      ),
    );
  }
}
