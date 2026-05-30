import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';

@RoutePage()
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(t.info.about_title, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(height: 20),
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text('WQ', style: TextStyle(color: context.colors.primary, fontSize: 28, fontWeight: FontWeight.w900)),
            ),
          ),
          SizedBox(height: 16),
          Text('WaslaQ', style: TextStyle(color: context.colors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(t.info.about_subtitle, style: TextStyle(color: context.colors.textSecondary, fontSize: 14)),
          SizedBox(height: 32),
          _infoSection(context, t.info.our_mission, t.info.our_mission_body),
          _infoSection(context, t.info.what_we_offer, t.info.what_we_offer_body),
          _infoSection(context, t.info.trust_safety, t.info.trust_safety_body),
          SizedBox(height: 20),
          Text(t.info.version(version: '1.0.0'), style: TextStyle(color: context.colors.textMuted, fontSize: 12)),
          SizedBox(height: 40),
        ]),
      ),
    );
  }

  static Widget _infoSection(BuildContext context, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(color: context.colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text(body, style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.6)),
      ]),
    );
  }
}
