import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslaq_app/i18n/strings.g.dart';
import 'package:waslaq_app/shared/theme/app_colors.dart';
import 'package:waslaq_app/core/providers/theme_provider.dart';
import 'package:waslaq_app/core/providers/locale_provider.dart';
import 'package:waslaq_app/core/providers/preferences_provider.dart';

@RoutePage()
class AppearanceSettingsScreen extends ConsumerWidget {
  const AppearanceSettingsScreen({super.key});

  TextStyle _getArabicFont(String fontName) {
    switch (fontName) {
      case 'Cairo':
        return GoogleFonts.cairo();
      case 'Tajawal':
        return GoogleFonts.tajawal();
      case 'Almarai':
        return GoogleFonts.almarai();
      default:
        return const TextStyle();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesProvider);
    final prefsNotifier = ref.read(preferencesProvider.notifier);
    final currentTheme = ref.watch(themeProvider);
    final currentLocale = ref.watch(localeProvider);
    final s = t.settings;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(s.appearanceTitle, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ─── LANGUAGE SECTION ───
          _buildSectionHeader(context, s.langSection),
          Card(
            color: context.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.colors.border),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.langAppLabel, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _LanguageCard(
                          label: 'العربية (Arabic)',
                          isSelected: currentLocale.languageCode == 'ar',
                          onTap: () => ref.read(localeProvider.notifier).setLocale(const Locale('ar')),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _LanguageCard(
                          label: 'English',
                          isSelected: currentLocale.languageCode == 'en',
                          onTap: () => ref.read(localeProvider.notifier).setLocale(const Locale('en')),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ─── THEME SECTION ───
          _buildSectionHeader(context, s.themeSection),
          Card(
            color: context.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.colors.border),
            ),
            child: Column(
              children: [
                _buildThemeTile(context, ref, AppThemeMode.light, Icons.light_mode_outlined, s.themeLight, currentTheme),
                Divider(height: 1, color: context.colors.border),
                _buildThemeTile(context, ref, AppThemeMode.dark, Icons.dark_mode_outlined, s.themeDark, currentTheme),
                Divider(height: 1, color: context.colors.border),
                _buildThemeTile(context, ref, AppThemeMode.system, Icons.brightness_auto_outlined, s.themeSystem, currentTheme),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ─── TEXT SIZE SECTION ───
          _buildSectionHeader(context, s.textSizeSection),
          Card(
            color: context.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.colors.border),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.textAdjustLabel, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildSizeChip(context, prefs, prefsNotifier, s.textSmall, 0.85),
                      _buildSizeChip(context, prefs, prefsNotifier, s.textNormal, 1.0),
                      _buildSizeChip(context, prefs, prefsNotifier, s.textLarge, 1.15),
                      _buildSizeChip(context, prefs, prefsNotifier, s.textXlarge, 1.30),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.colors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.colors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.textPreviewLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 6),
                        Text(
                          'The quick brown fox — WaslaQ',
                          style: TextStyle(
                            fontSize: 14 * prefs.textScale,
                            fontWeight: prefs.boldText ? FontWeight.bold : FontWeight.normal,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ─── ARABIC FONT SECTION ───
          _buildSectionHeader(context, s.arabicFontSection),
          Card(
            color: context.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.colors.border),
            ),
            child: Column(
              children: [
                _buildFontTile(context, prefs, prefsNotifier, 'default', '${s.fontDefault} (الافتراضي)', 'أهلاً بك في واصلك - سوقك الاجتماعي الفلسطيني'),
                Divider(height: 1, color: context.colors.border),
                _buildFontTile(context, prefs, prefsNotifier, 'Cairo', '${s.fontCairo} (خط كيرو)', 'أهلاً بك في واصلك - سوقك الاجتماعي الفلسطيني'),
                Divider(height: 1, color: context.colors.border),
                _buildFontTile(context, prefs, prefsNotifier, 'Tajawal', '${s.fontTajawal} (خط تجول)', 'أهلاً بك في واصلك - سوقك الاجتماعي الفلسطيني'),
                Divider(height: 1, color: context.colors.border),
                _buildFontTile(context, prefs, prefsNotifier, 'Almarai', '${s.fontAlmarai} (خط المراعي)', 'أهلاً بك في واصلك - سوقك الاجتماعي الفلسطيني'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ─── ACCESSIBILITY SECTION ───
          _buildSectionHeader(context, s.accessibilitySection),
          Card(
            color: context.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.colors.border),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  activeColor: context.colors.primary,
                  title: Text(s.boldText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  value: prefs.boldText,
                  onChanged: (val) {
                    prefsNotifier.update(prefs.copyWith(boldText: val));
                  },
                ),
                Divider(height: 1, color: context.colors.border),
                SwitchListTile(
                  activeColor: context.colors.primary,
                  title: Text(s.reduceAnim, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(s.reduceAnimSub, style: TextStyle(fontSize: 11)),
                  value: prefs.reduceAnimations,
                  onChanged: (val) {
                    prefsNotifier.update(prefs.copyWith(reduceAnimations: val));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(color: context.colors.textMuted, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildThemeTile(BuildContext context, WidgetRef ref, AppThemeMode mode, IconData icon, String label, AppThemeMode selectedMode) {
    final isSelected = selectedMode == mode;
    return ListTile(
      leading: Icon(icon, color: isSelected ? context.colors.primary : context.colors.textSecondary),
      title: Text(label, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      trailing: isSelected ? Icon(Icons.check, color: context.colors.primary) : null,
      onTap: () => ref.read(themeProvider.notifier).setMode(mode),
    );
  }

  Widget _buildSizeChip(BuildContext context, AppPreferences prefs, PreferencesNotifier notifier, String label, double scale) {
    final isSelected = prefs.textScale == scale;
    return ChoiceChip(
      label: Text(label, style: TextStyle(color: isSelected ? Colors.white : context.colors.textPrimary)),
      selected: isSelected,
      selectedColor: context.colors.primary,
      backgroundColor: context.colors.surface,
      onSelected: (selected) {
        if (selected) {
          notifier.update(prefs.copyWith(textScale: scale));
        }
      },
    );
  }

  Widget _buildFontTile(BuildContext context, AppPreferences prefs, PreferencesNotifier notifier, String fontName, String label, String sampleText) {
    final isSelected = prefs.arabicFont == fontName;
    return RadioListTile<String>(
      title: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          sampleText,
          style: _getArabicFont(fontName).copyWith(
            color: context.colors.textSecondary,
            fontSize: 13,
          ),
        ),
      ),
      value: fontName,
      groupValue: prefs.arabicFont,
      activeColor: context.colors.primary,
      onChanged: (val) {
        if (val != null) {
          notifier.update(prefs.copyWith(arabicFont: val));
        }
      },
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? context.colors.primary.withOpacity(0.08) : context.colors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? context.colors.primary : context.colors.border, width: isSelected ? 2 : 1),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? context.colors.primary : context.colors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
