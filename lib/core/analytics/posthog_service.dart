// lib/core/analytics/posthog_service.dart

import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import '../config/app_config.dart';

class AnalyticsService {
  AnalyticsService._();

  static Future<void> initialize() async {
    final config = PostHogConfig(AppConfig.postHogApiKey);
    config.host = AppConfig.postHogHost;
    config.debug = kDebugMode;
    config.captureApplicationLifecycleEvents = true;
    config.sessionReplayConfig.maskAllTexts = true;
    config.sessionReplayConfig.maskAllImages = true;
    await Posthog().setup(config);
  }

  // Attach the same customer_id used on web + backend so funnels are one person.
  static Future<void> identify(String customerId, {String? email, String? displayName}) async {
    await Posthog().identify(
      userId: customerId,
      userProperties: {
        if (email != null) 'email': email,
        if (displayName != null) 'displayName': displayName,
      },
    );
  }

  static Future<void> reset() async {
    await Posthog().reset();
  }
}
