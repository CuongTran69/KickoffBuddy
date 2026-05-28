import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/time/timezone_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TimezoneService.initialize();
  runApp(const ProviderScope(child: KickoffBuddyApp()));
}
