import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../providers/vendor_providers.dart';
import '../../../../i18n/strings.g.dart';

@RoutePage()
class VendorImportScreen extends ConsumerStatefulWidget {
  const VendorImportScreen({super.key});

  @override
  ConsumerState<VendorImportScreen> createState() => _VendorImportScreenState();
}

class _VendorImportScreenState extends ConsumerState<VendorImportScreen> {
  bool _isLoading = false;
  bool _isDownloading = false;
  File? _selectedFile;
  Map<String, dynamic>? _results;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final size = await file.length();
      if (size > 5 * 1024 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t.vendor_import.file_too_large)),
          );
        }
        return;
      }
      setState(() => _selectedFile = file);
    }
  }

  Future<void> _importProducts() async {
    if (_selectedFile == null) return;
    setState(() { _isLoading = true; _results = null; });

    try {
      final repo = ref.read(vendorRepositoryProvider);
      final res = await repo.importProducts(_selectedFile!);
      setState(() => _results = res['summary']);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.vendor_import.import_completed),
              backgroundColor: context.colors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.vendor_import.import_failed(error: e.toString())),
              backgroundColor: context.colors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _exportProducts() async {
    setState(() => _isDownloading = true);
    try {
      final repo = ref.read(vendorRepositoryProvider);
      final bytes = await repo.exportProducts();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/waslaq_products_export.xlsx');
      await file.writeAsBytes(bytes);
      await Share.shareXFiles([XFile(file.path)], text: t.vendor_import.export_share_text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.vendor_import.export_failed(error: e.toString())),
              backgroundColor: context.colors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(t.vendor_import.title,
            style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _results == null ? _buildUploadState() : _buildResultsState(),
      ),
    );
  }

  Widget _buildUploadState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('1. ${t.vendor_import.step1_title}',
                  style: TextStyle(color: context.colors.textPrimary,
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Text(t.vendor_import.step1_desc,
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isDownloading ? null : _exportProducts,
                  icon: _isDownloading
                      ? SizedBox(width: 16, height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2,
                              color: context.colors.primary))
                      : Icon(Icons.download_outlined, color: context.colors.primary),
                  label: Text(t.vendor_import.step1_btn,
                      style: TextStyle(color: context.colors.primary)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: context.colors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('2. ${t.vendor_import.step2_title}',
                  style: TextStyle(color: context.colors.textPrimary,
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Text(t.vendor_import.step2_desc,
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedFile != null
                          ? context.colors.primary
                          : context.colors.border,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: context.colors.surfaceVariant,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file_outlined,
                            size: 40,
                            color: _selectedFile != null
                                ? context.colors.primary
                                : context.colors.textMuted),
                        const SizedBox(height: 8),
                        Text(
                          _selectedFile != null
                              ? _selectedFile!.path.split('/').last
                              : t.vendor_import.tap_to_select,
                          style: TextStyle(
                              color: _selectedFile != null
                                  ? context.colors.textPrimary
                                  : context.colors.textMuted,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading || _selectedFile == null ? null : _importProducts,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    disabledBackgroundColor: context.colors.border,
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(t.vendor_import.start_import,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultsState() {
    final created = _results?['created'] ?? 0;
    final failed = _results?['failed'] ?? 0;
    final rows = _results?['rows'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(t.vendor_import.results_title,
            style: TextStyle(color: context.colors.textPrimary,
                fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 16),
        _Card(
          color: context.colors.success.withValues(alpha: 0.08),
          borderColor: context.colors.success.withValues(alpha: 0.3),
          child: Row(children: [
            Icon(Icons.check_circle_outline, color: context.colors.success),
            const SizedBox(width: 12),
            Text(t.vendor_import.products_created(count: created.toString()),
                style: TextStyle(color: context.colors.success, fontWeight: FontWeight.bold)),
          ]),
        ),
        if (failed > 0) ...[
          const SizedBox(height: 8),
          _Card(
            color: context.colors.error.withValues(alpha: 0.08),
            borderColor: context.colors.error.withValues(alpha: 0.3),
            child: Row(children: [
              Icon(Icons.error_outline, color: context.colors.error),
              const SizedBox(width: 12),
              Text(t.vendor_import.rows_failed(count: failed.toString()),
                  style: TextStyle(color: context.colors.error, fontWeight: FontWeight.bold)),
            ]),
          ),
        ],
        if (rows.isNotEmpty) ...[
          const SizedBox(height: 16),
          ...rows.where((r) => r['status'] != 'created').map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _Card(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Row ${r['row_number']}: ${r['product_title']}',
                    style: TextStyle(color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text((r['errors'] as List).join('\n'),
                    style: TextStyle(color: context.colors.error, fontSize: 12)),
              ]),
            ),
          )),
        ],
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() { _selectedFile = null; _results = null; }),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(t.vendor_import.import_another,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context.maybePop(),
          child: Text(t.vendor_import.done,
              style: TextStyle(color: context.colors.textSecondary)),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Color? borderColor;
  const _Card({required this.child, this.color, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor ?? context.colors.border),
      ),
      child: child,
    );
  }
}
