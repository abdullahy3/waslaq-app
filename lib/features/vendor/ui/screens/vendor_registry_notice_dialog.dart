// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import '../../../../core/api/medusa_client.dart';

Future<void> showVendorRegistryNotice(BuildContext context) async {
  bool agreed = false;

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text(
            'تنويه هام',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'حسابك هنا في واصلك لا يعفيك من وجود سجل تجاري حسب قانون وزارة الاقتصاد',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.6),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: agreed,
                    onChanged: (v) => setState(() => agreed = v ?? false),
                  ),
                  const Text('أتفهم ذلك', style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: agreed
                    ? () async {
                        try {
                          await MedusaClient.instance.post(
                            '/store/vendors/me/agree-registry',
                            data: <String, dynamic>{},
                          );
                        } catch (_) {}
                        if (ctx.mounted) Navigator.of(ctx).pop();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 44),
                ),
                child: const Text('حسناً'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
