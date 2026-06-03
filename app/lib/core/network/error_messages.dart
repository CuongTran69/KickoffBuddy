import '../../l10n/app_localizations.dart';
import 'api_client.dart';

/// Maps a caught error/exception to a user-facing localized message.
///
/// Network-related failures map to [AppLocalizations.common_error_network];
/// everything else maps to [AppLocalizations.common_error_generic]. Raw
/// exception detail is intentionally NOT surfaced to users (design D2) — keep
/// it in `debugPrint` at the call site.
String friendlyErrorMessage(AppLocalizations l10n, Object error) {
  if (error is WorldCupApiException) {
    return l10n.common_error_network;
  }
  return l10n.common_error_generic;
}
