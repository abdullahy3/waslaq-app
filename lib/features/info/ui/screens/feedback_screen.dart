import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/api/medusa_client.dart';

@RoutePage()
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _messageCtrl = TextEditingController();
  String _type = 'general';
  int _rating = 0;
  bool _sending = false;
  String? _success;
  String? _error;

  @override
  void dispose() { _messageCtrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (_messageCtrl.text.trim().isEmpty) {
      setState(() => _error = t.info.write_feedback_required);
      return;
    }
    setState(() { _sending = true; _error = null; _success = null; });
    try {
      await MedusaClient.instance.post('/store/support', data: {
        'subject': 'Feedback: $_type',
        'message': _messageCtrl.text.trim(),
        'type': 'feedback',
        'name': 'App User',
        'email': 'feedback@waslaq.com',
      });
      _messageCtrl.clear();
      setState(() { _success = t.info.thank_you_feedback; _rating = 0; });
    } catch (e) {
      setState(() => _error = t.info.failed_submit_feedback);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(t.info.feedback_title, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background, iconTheme: IconThemeData(color: context.colors.textPrimary), elevation: 0,
      ),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t.info.help_us_improve, style: TextStyle(color: context.colors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text(t.info.feedback_desc, style: TextStyle(color: context.colors.textSecondary, fontSize: 14)),
        SizedBox(height: 24),
        if (_success != null) Container(width: double.infinity, padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(color: context.colors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Text(_success!, style: TextStyle(color: context.colors.success, fontSize: 13))),
        if (_error != null) Container(width: double.infinity, padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(color: context.colors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Text(_error!, style: TextStyle(color: context.colors.error, fontSize: 13))),
        // Type selector
        Text(t.info.category, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
        SizedBox(height: 8),
        Wrap(spacing: 8, children: [
          {'value': 'general', 'label': t.info.type_general},
          {'value': 'bug', 'label': t.info.type_bug},
          {'value': 'feature', 'label': t.info.type_feature},
          {'value': 'design', 'label': t.info.type_design},
        ].map((item) => ChoiceChip(
          label: Text(item['label']!, style: TextStyle(fontSize: 12)),
          selected: _type == item['value'], selectedColor: context.colors.primary,
          onSelected: (_) => setState(() => _type = item['value']!),
        )).toList()),
        SizedBox(height: 20),
        // Rating
        Text(t.info.rating, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
        SizedBox(height: 8),
        Row(children: List.generate(5, (i) => GestureDetector(
          onTap: () => setState(() => _rating = i + 1),
          child: Padding(padding: const EdgeInsets.only(right: 8),
            child: Icon(i < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                color: i < _rating ? Colors.amber : context.colors.textMuted, size: 32)),
        ))),
        SizedBox(height: 20),
        TextField(controller: _messageCtrl, maxLines: 5,
          style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
          decoration: InputDecoration(labelText: t.info.your_feedback, labelStyle: TextStyle(color: context.colors.textSecondary),
            hintText: t.info.feedback_hint, hintStyle: TextStyle(color: context.colors.textMuted),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.colors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.colors.primary)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12))),
        SizedBox(height: 24),
        SizedBox(width: double.infinity, height: 48, child: ElevatedButton(
          onPressed: _sending ? null : _submit,
          style: ElevatedButton.styleFrom(backgroundColor: context.colors.primary, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: _sending ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Text(t.info.submit_feedback, style: const TextStyle(fontWeight: FontWeight.bold)))),
      ])),
    );
  }
}
