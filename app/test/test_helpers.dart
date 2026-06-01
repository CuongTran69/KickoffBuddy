import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kickoff_buddy/l10n/app_localizations.dart';

/// Wraps [child] in a [MaterialApp] with localization delegates configured.
///
/// Use this in widget tests that render widgets using [AppLocalizations.of(context)].
/// Default locale is Vietnamese (vi) to match the app's default.
Widget withLocalizations(
  Widget child, {
  Locale locale = const Locale('vi'),
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('vi'),
      Locale('en'),
    ],
    home: Scaffold(body: child),
  );
}
