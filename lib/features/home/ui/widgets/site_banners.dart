import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/api/medusa_client.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/navigation/app_links.dart';
import '../../../../shared/theme/app_colors.dart';

/// One fetch of /store/site-config, shared by the announcement bar + popup.
final siteConfigProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  try {
    final res = await MedusaClient.instance.get('/store/site-config');
    return (res.data as Map<String, dynamic>?) ?? const {};
  } catch (_) {
    return const {};
  }
});

const _storage = FlutterSecureStorage();
final _sessionShownPopups = <String>{};

Color _hexColor(String? hex, Color fallback) {
  if (hex == null) return fallback;
  var h = hex.replaceFirst('#', '').trim();
  if (h.length == 6) h = 'FF$h';
  final v = int.tryParse(h, radix: 16);
  return v == null ? fallback : Color(v);
}

String _localized(Map item, String base, bool isAr) {
  final ar = item['${base}_ar'] as String?;
  final en = item['${base}_en'] as String?;
  if (isAr && ar != null && ar.isNotEmpty) return ar;
  return en ?? '';
}

bool _isActive(Map e) {
  if (e['is_active'] != true) return false;
  final now = DateTime.now();
  final s = e['starts_at'];
  final en = e['ends_at'];
  if (s != null && (DateTime.tryParse(s.toString())?.isAfter(now) ?? false)) return false;
  if (en != null && (DateTime.tryParse(en.toString())?.isBefore(now) ?? false)) return false;
  return true;
}

List<Map<String, dynamic>> _activeItems(Map<String, dynamic> config, String key) {
  final raw = config[key];
  if (raw is! List) return const [];
  return raw.map((e) => e as Map<String, dynamic>).where(_isActive).toList();
}

// ── Announcement bar ─────────────────────────────────────────────────────────

class SiteAnnouncementBar extends ConsumerWidget {
  const SiteAnnouncementBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(siteConfigProvider).valueOrNull ?? const {};
    final list = _activeItems(config, 'announcements');
    if (list.isEmpty) return const SizedBox.shrink();

    final a = list.first;
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final text = _localized(a, 'text', isAr);
    if (text.isEmpty) return const SizedBox.shrink();

    final linkUrl = (a['link_url'] as String?)?.trim() ?? '';
    final linkText = _localized(a, 'link_text', isAr);
    final fg = _hexColor(a['text_color'] as String?, Colors.white);

    return Material(
      color: _hexColor(a['bg_color'] as String?, context.colors.primary),
      child: InkWell(
        onTap: linkUrl.isEmpty ? null : () => openWaslaqLink(linkUrl),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              if (linkUrl.isNotEmpty && linkText.isNotEmpty) ...[
                const SizedBox(width: 6),
                Text(
                  linkText,
                  style: TextStyle(
                    color: fg,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
              if (linkUrl.isNotEmpty) Icon(Icons.chevron_right, size: 16, color: fg),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Popup modal (image + title + body + CTA + close X, frequency-gated) ───────

class SitePopupHost extends ConsumerStatefulWidget {
  const SitePopupHost({super.key});

  @override
  ConsumerState<SitePopupHost> createState() => _SitePopupHostState();
}

class _SitePopupHostState extends ConsumerState<SitePopupHost> {
  bool _handled = false;

  Future<bool> _seen(Map p) async {
    final id = p['id'] as String? ?? '';
    final freq = p['frequency'] as String? ?? 'once_ever';
    if (freq == 'once_per_session') return _sessionShownPopups.contains(id);
    final v = await _storage.read(key: 'wq_popup_$id');
    if (v == null) return false;
    if (freq == 'once_ever') return true;
    return v == _today(); // once_per_day
  }

  Future<void> _markSeen(Map p) async {
    final id = p['id'] as String? ?? '';
    final freq = p['frequency'] as String? ?? 'once_ever';
    if (freq == 'once_per_session') {
      _sessionShownPopups.add(id);
    } else if (freq == 'once_ever') {
      await _storage.write(key: 'wq_popup_$id', value: '1');
    } else {
      await _storage.write(key: 'wq_popup_$id', value: _today());
    }
  }

  String _today() {
    final n = DateTime.now();
    return '${n.year}-${n.month}-${n.day}';
  }

  Future<void> _maybeShow(Map<String, dynamic> config) async {
    if (_handled || !mounted) return;
    final popups = _activeItems(config, 'popups');
    for (final p in popups) {
      if (!await _seen(p)) {
        if (_handled || !mounted) return;
        _handled = true;
        await _markSeen(p);
        if (!mounted) return;
        showDialog(
          context: context,
          barrierColor: Colors.black54,
          builder: (_) => _SitePopupDialog(popup: p),
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(siteConfigProvider, (_, next) {
      next.whenData(_maybeShow);
    });
    final config = ref.watch(siteConfigProvider).valueOrNull;
    if (config != null && !_handled) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShow(config));
    }
    return const SizedBox.shrink();
  }
}

class _SitePopupDialog extends ConsumerWidget {
  final Map<String, dynamic> popup;
  const _SitePopupDialog({required this.popup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final title = _localized(popup, 'title', isAr);
    final body = _localized(popup, 'body', isAr);
    final ctaText = _localized(popup, 'cta_text', isAr);
    final ctaLink = (popup['cta_link'] as String?)?.trim() ?? '';
    final image = (popup['image_url'] as String?)?.trim() ?? '';

    return Dialog(
      backgroundColor: context.colors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (image.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  memCacheWidth: 700,
                  errorWidget: (_, __, ___) => const SizedBox.shrink(),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title.isNotEmpty)
                      Text(
                        title,
                        style: TextStyle(
                          color: context.colors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (body.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        body,
                        style: TextStyle(color: context.colors.textSecondary, fontSize: 14, height: 1.4),
                      ),
                    ],
                    if (ctaText.isNotEmpty && ctaLink.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            openWaslaqLink(ctaLink);
                          },
                          child: Text(ctaText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 6,
            right: 6,
            child: Material(
              color: Colors.black38,
              shape: const CircleBorder(),
              child: IconButton(
                iconSize: 20,
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
