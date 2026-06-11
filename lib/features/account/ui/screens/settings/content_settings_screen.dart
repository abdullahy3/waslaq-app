import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waslaq_app/i18n/strings.g.dart';
import 'package:waslaq_app/shared/theme/app_colors.dart';
import 'package:waslaq_app/core/providers/preferences_provider.dart';
import 'package:waslaq_app/features/vendor/providers/vendor_providers.dart';
import 'package:waslaq_app/features/account/providers/account_providers.dart';

@RoutePage()
class ContentSettingsScreen extends ConsumerStatefulWidget {
  const ContentSettingsScreen({super.key});

  @override
  ConsumerState<ContentSettingsScreen> createState() => _ContentSettingsScreenState();
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;

  const _ProfileField({required this.label, required this.controller, this.hint});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: context.colors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: context.colors.textMuted, fontSize: 13),
        filled: true,
        fillColor: context.colors.surface,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.border)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.primary)),
      ),
    );
  }
}

class _ContentSettingsScreenState extends ConsumerState<ContentSettingsScreen> {
  final TextEditingController _keywordController = TextEditingController();
  bool _vacationMode = false;
  bool _isLoadingVacationMode = true;

  @override
  void initState() {
    super.initState();
    _loadVacationMode();
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  Future<void> _loadVacationMode() async {
    try {
      // In a real app we might fetch vendor profile to see if vacation mode is active.
      // Here, let's pretend to load or set to false as default, or fetch.
      // Let's assume we fetch or keep it false.
      setState(() {
        _vacationMode = false;
        _isLoadingVacationMode = false;
      });
    } catch (_) {
      setState(() => _isLoadingVacationMode = false);
    }
  }

  Future<void> _toggleVacationMode(bool val) async {
    setState(() {
      _vacationMode = val;
    });
    try {
      await ref.read(accountRepositoryProvider).setVacationMode(val);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(val ? 'Vacation Mode is now ON' : 'Vacation Mode is now OFF'),
          backgroundColor: context.colors.success,
        ),
      );
    } catch (e) {
      setState(() {
        _vacationMode = !val; // revert
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to set vacation mode: $e'), backgroundColor: context.colors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(preferencesProvider);
    final prefsNotifier = ref.read(preferencesProvider.notifier);
    final isVendor = ref.watch(isVendorProvider).valueOrNull ?? false;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(t.settings.contentScreenTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ─── FEED LANGUAGE SECTION ───
          _buildSectionHeader(t.settings.contentFeedLangSection),
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
                  const Text('Content Language Filter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<String>(
                      style: SegmentedButton.styleFrom(
                        selectedBackgroundColor: context.colors.primary,
                        selectedForegroundColor: Colors.white,
                      ),
                      segments: const [
                        ButtonSegment(value: 'arabic', label: Text('Arabic Only', style: TextStyle(fontSize: 11))),
                        ButtonSegment(value: 'both', label: Text('Both', style: TextStyle(fontSize: 11))),
                        ButtonSegment(value: 'english', label: Text('English Only', style: TextStyle(fontSize: 11))),
                      ],
                      selected: {prefs.contentLanguage},
                      onSelectionChanged: (val) {
                        prefsNotifier.update(prefs.copyWith(contentLanguage: val.first));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ─── MUTED KEYWORDS SECTION ───
          _buildSectionHeader(t.settings.contentMutedSection),
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
                  const Text('Muted Words List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('Posts containing these words will be hidden from your feed.',
                      style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 12),
                  if (prefs.muteKeywords.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: prefs.muteKeywords.map((kw) {
                        return Chip(
                          label: Text(kw, style: TextStyle(color: context.colors.textPrimary)),
                          backgroundColor: context.colors.background,
                          deleteIcon: Icon(Icons.close, size: 14, color: context.colors.textSecondary),
                          onDeleted: () {
                            final newList = List<String>.from(prefs.muteKeywords)..remove(kw);
                            prefsNotifier.update(prefs.copyWith(muteKeywords: newList));
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                  TextField(
                    controller: _keywordController,
                    style: TextStyle(color: context.colors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Add muted keyword and press Enter',
                      hintStyle: TextStyle(color: context.colors.textMuted),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          final val = _keywordController.text.trim();
                          if (val.isNotEmpty) {
                            final newList = List<String>.from(prefs.muteKeywords)..add(val);
                            prefsNotifier.update(prefs.copyWith(muteKeywords: newList));
                            _keywordController.clear();
                          }
                        },
                      ),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.border)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.primary)),
                    ),
                    onSubmitted: (val) {
                      final clean = val.trim();
                      if (clean.isNotEmpty) {
                        final newList = List<String>.from(prefs.muteKeywords)..add(clean);
                        prefsNotifier.update(prefs.copyWith(muteKeywords: newList));
                        _keywordController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ─── POSTS SECTION ───
          _buildSectionHeader(t.settings.contentPostsSection),
          Card(
            color: context.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.colors.border),
            ),
            child: ListTile(
              title: const Text('Default Post Visibility', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              trailing: DropdownButton<String>(
                value: prefs.postDefaultVisibility,
                dropdownColor: context.colors.surface,
                style: TextStyle(color: context.colors.textPrimary),
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'public', child: Text('Public (all members)')),
                  DropdownMenuItem(value: 'followers', child: Text('Followers Only')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    prefsNotifier.update(prefs.copyWith(postDefaultVisibility: val));
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ─── FEED BEHAVIOR SECTION ───
          _buildSectionHeader(t.settings.contentFeedSection),
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
                  const Text('Auto-Refresh Interval', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('How often the feed checks for new posts (affects battery)',
                      style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<int>(
                      style: SegmentedButton.styleFrom(
                        selectedBackgroundColor: context.colors.primary,
                        selectedForegroundColor: Colors.white,
                      ),
                      segments: const [
                        ButtonSegment(value: 1, label: Text('1 Min', style: TextStyle(fontSize: 10))),
                        ButtonSegment(value: 5, label: Text('5 Min', style: TextStyle(fontSize: 10))),
                        ButtonSegment(value: 15, label: Text('15 Min', style: TextStyle(fontSize: 10))),
                        ButtonSegment(value: 0, label: Text('Manual', style: TextStyle(fontSize: 10))),
                      ],
                      selected: {prefs.autoRefreshMinutes},
                      onSelectionChanged: (val) {
                        prefsNotifier.update(prefs.copyWith(autoRefreshMinutes: val.first));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ─── VENDOR VACATION MODE SECTION ───
          if (isVendor) ...[
            _buildSectionHeader(t.settings.contentVendorSection),
            Card(
              color: context.colors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: context.colors.border),
              ),
              child: SwitchListTile(
                activeColor: context.colors.primary,
                title: const Text('Vacation Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('When ON, your store shows a vacation banner and no new orders can be placed',
                    style: TextStyle(fontSize: 11)),
                value: _vacationMode,
                onChanged: _isLoadingVacationMode ? null : _toggleVacationMode,
              ),
            ),
            const SizedBox(height: 20),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(color: context.colors.textMuted, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.1),
      ),
    );
  }
}
