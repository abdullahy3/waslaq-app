import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/api/medusa_client.dart';
import '../../../../router/app_router.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/ils_formatter.dart';

final _downloadsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final res = await MedusaClient.instance.get('/store/customers/me/downloads');
  final list = res.data['downloads'] as List<dynamic>? ?? [];
  return list.cast<Map<String, dynamic>>();
});

@RoutePage()
class DigitalVaultScreen extends ConsumerStatefulWidget {
  const DigitalVaultScreen({super.key});

  @override
  ConsumerState<DigitalVaultScreen> createState() => _DigitalVaultScreenState();
}

class _DigitalVaultScreenState extends ConsumerState<DigitalVaultScreen> {
  final Set<String> _loadingIds = {};

  String _formatSize(dynamic bytes) {
    if (bytes == null) return '';
    final b = (bytes as num).toDouble();
    if (b < 1024) return '${b.toStringAsFixed(0)} B';
    if (b < 1024 * 1024) return '${(b / 1024).toStringAsFixed(1)} KB';
    return '${(b / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatExpiry(String? expiresAt) {
    if (expiresAt == null) return '';
    final dt = DateTime.tryParse(expiresAt);
    if (dt == null) return '';
    final now = DateTime.now();
    if (dt.isBefore(now)) return 'منتهية الصلاحية';
    final diff = dt.difference(now);
    if (diff.inDays > 30) return 'تنتهي بعد ${diff.inDays ~/ 30} شهر';
    if (diff.inDays > 0) return 'تنتهي بعد ${diff.inDays} يوم';
    if (diff.inHours > 0) return 'تنتهي بعد ${diff.inHours} ساعة';
    return 'تنتهي قريباً';
  }

  Future<void> _download(String accessId) async {
    if (_loadingIds.contains(accessId)) return;
    setState(() => _loadingIds.add(accessId));

    try {
      final res = await MedusaClient.instance.get('/store/customers/me/downloads/$accessId');
      final url = res.data['url'] as String?;

      if (url == null || url.isEmpty) {
        _showError('رابط التنزيل غير متاح');
        return;
      }

      final uri = Uri.tryParse(url);
      if (uri == null) {
        _showError('رابط التنزيل غير صالح');
        return;
      }

      if (!await canLaunchUrl(uri)) {
        _showError('تعذر فتح الملف');
        return;
      }

      await launchUrl(uri, mode: LaunchMode.externalApplication);
      // Refresh list so download_count updates in the UI
      ref.invalidate(_downloadsProvider);
    } on DioException catch (e) {
      final msg = (e.response?.data as Map<String, dynamic>?)?['message'] as String?;
      _showError(msg ?? 'فشل التنزيل');
    } catch (_) {
      _showError('حدث خطأ أثناء التنزيل');
    } finally {
      if (mounted) setState(() => _loadingIds.remove(accessId));
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: context.colors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final downloadsAsync = ref.watch(_downloadsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        title: Text(
          'الخزنة الرقمية',
          style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: context.colors.border),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: context.colors.textMuted),
            onPressed: () => ref.invalidate(_downloadsProvider),
          ),
        ],
      ),
      body: downloadsAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: context.colors.primary)),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: context.colors.error),
              const SizedBox(height: 12),
              Text('فشل تحميل المشتريات الرقمية', style: TextStyle(color: context.colors.textMuted)),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(_downloadsProvider),
                style: FilledButton.styleFrom(backgroundColor: context.colors.primary),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
        data: (downloads) {
          if (downloads.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_download_outlined, size: 72, color: context.colors.textMuted.withValues(alpha: 0.4)),
                  const SizedBox(height: 20),
                  Text(
                    'لا توجد مشتريات رقمية',
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'المنتجات الرقمية التي تشتريها ستظهر هنا',
                    style: TextStyle(color: context.colors.textMuted, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: downloads.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = downloads[index];
              final accessId = item['id'] as String;
              final productId = item['product_id'] as String?;
              final title = item['product_title'] as String? ?? 'منتج رقمي';
              final thumbnail = item['thumbnail'] as String?;
              final mimeType = item['mime_type'] as String?;
              final fileSize = _formatSize(item['file_size']);
              final expiresAt = item['expires_at'] as String?;
              final downloadCount = item['download_count'] as int? ?? 0;
              final downloadLimit = item['download_limit'] as int?;
              final rawPrice = item['price'];
              final price = rawPrice != null ? (rawPrice as num).toDouble() : null;
              final isExpired = expiresAt != null &&
                  DateTime.tryParse(expiresAt)?.isBefore(DateTime.now()) == true;
              final limitReached = downloadLimit != null && downloadCount >= downloadLimit;
              final canDownload = !isExpired && !limitReached;
              final isLoading = _loadingIds.contains(accessId);

              return GestureDetector(
                onTap: productId != null
                    ? () => context.router.push(ProductRoute(id: productId))
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.colors.border.withValues(alpha: 0.6)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        child: thumbnail != null && thumbnail.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: thumbnail,
                                width: 90,
                                height: 110,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => _PlaceholderBox(colors: context.colors, height: 110),
                                errorWidget: (_, __, ___) => _PlaceholderBox(colors: context.colors, height: 110),
                              )
                            : _PlaceholderBox(colors: context.colors, height: 110),
                      ),
                      // Info
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  color: context.colors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (price != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  ILSFormatter.format(price),
                                  style: TextStyle(
                                    color: context.colors.primary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  if (mimeType != null) ...[
                                    _Tag(label: mimeType.split('/').last.toUpperCase(), colors: context.colors),
                                    const SizedBox(width: 6),
                                  ],
                                  if (fileSize.isNotEmpty)
                                    _Tag(label: fileSize, colors: context.colors),
                                ],
                              ),
                              const SizedBox(height: 4),
                              if (expiresAt != null)
                                Text(
                                  _formatExpiry(expiresAt),
                                  style: TextStyle(
                                    color: isExpired ? context.colors.error : context.colors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              if (downloadLimit != null) ...[
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.download_done_rounded,
                                      size: 12,
                                      color: limitReached ? context.colors.error : context.colors.textMuted,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$downloadCount / $downloadLimit تنزيل',
                                      style: TextStyle(
                                        color: limitReached ? context.colors.error : context.colors.textMuted,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 36,
                                child: FilledButton.icon(
                                  onPressed: canDownload && !isLoading
                                      ? () => _download(accessId)
                                      : null,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: canDownload
                                        ? context.colors.primary
                                        : context.colors.surfaceVariant,
                                    foregroundColor: canDownload
                                        ? Colors.white
                                        : context.colors.textMuted,
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    minimumSize: const Size(0, 36),
                                  ),
                                  icon: isLoading
                                      ? SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Icon(
                                          isExpired ? Icons.timer_off_outlined
                                              : limitReached ? Icons.block_outlined
                                              : Icons.download_rounded,
                                          size: 16,
                                        ),
                                  label: Text(
                                    isLoading ? 'جاري التنزيل...'
                                        : isExpired ? 'انتهت الصلاحية'
                                        : limitReached ? 'تجاوزت الحد'
                                        : 'تنزيل',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _PlaceholderBox extends StatelessWidget {
  final AppColors colors;
  final double height;
  const _PlaceholderBox({required this.colors, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: height,
      color: colors.surfaceVariant,
      child: Icon(Icons.insert_drive_file_outlined, size: 36, color: colors.textMuted),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final AppColors colors;
  const _Tag({required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: TextStyle(color: colors.textMuted, fontSize: 10)),
    );
  }
}
