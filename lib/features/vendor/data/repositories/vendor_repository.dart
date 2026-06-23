// lib/features/vendor/data/repositories/vendor_repository.dart

import 'dart:io';
import 'package:dio/dio.dart';
import '../models/vendor_dashboard_model.dart';
import '../../../../core/error/app_exception.dart';

class VendorRepository {
  final Dio _client;
  VendorRepository(this._client);

  // ─── Overview ───────────────────────────────────────────────────────────────

  Future<VendorDashboardModel> getDashboard() async {
    try {
      final res = await _client.get('/store/vendors/me/dashboard');
      return VendorDashboardModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  // ─── Orders ─────────────────────────────────────────────────────────────────

  Future<List<VendorOrder>> getOrders() async {
    try {
      final res = await _client.get('/store/vendors/me/orders');
      final list = res.data['vendor_orders'] as List<dynamic>? ?? [];
      return list.map((e) => VendorOrder.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  Future<void> markShipped(String vendorOrderId) async {
    try {
      await _client.post('/store/vendors/me/orders/$vendorOrderId/ship');
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  // ─── Products ───────────────────────────────────────────────────────────────

  Future<List<VendorProduct>> getProducts() async {
    try {
      final res = await _client.get('/store/vendors/me/products');
      final list = res.data['products'] as List<dynamic>? ?? [];
      return list.map((e) => VendorProduct.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  Future<void> updateProduct(String productId, {
    String? title,
    String? description,
    double? price,
    List<String>? imageUrls,
    String? sku,
    bool? manageInventory,
    int? inventoryQuantity,
    String? variantId,
    List<String>? allVariantIds,
    String? digitalFileUrl,
  }) async {
    try {
      // Build variants list — update ALL variants with the new inventory/price
      // so multi-variant products don't silently miss updates
      final variantIds = (allVariantIds?.isNotEmpty == true)
          ? allVariantIds!
          : (variantId != null ? [variantId] : []);

      final variants = variantIds.map((vid) => {
        'id': vid,
        if (title != null) 'title': 'Default',
        if (price != null) 'prices': [{'amount': price, 'currency_code': 'ils'}],
        if (sku != null && sku.isNotEmpty) 'sku': sku,
        if (manageInventory != null) 'manage_inventory': manageInventory,
        if (inventoryQuantity != null) 'inventory_quantity': inventoryQuantity,
      }).toList();

      await _client.put('/store/vendors/me/products/$productId', data: {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (imageUrls != null) 'image_urls': imageUrls,
        if (digitalFileUrl != null) 'digital_file_url': digitalFileUrl,
        'variants': variants,
      });
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  /// Upload images to R2 via backend. Returns list of public URLs.
  Future<List<String>> uploadImages(List<File> files) async {
    try {
      final formData = FormData();
      for (final file in files) {
        final name = file.path.split('/').last;
        formData.files.add(MapEntry(
          'files',
          await MultipartFile.fromFile(file.path, filename: name),
        ));
      }
      final res = await _client.post(
        '/store/vendors/me/uploads',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return List<String>.from(res.data['uploaded_urls'] ?? []);
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  Future<void> createProduct({
    required String title,
    String? description,
    required String productType,
    required double price,
    required List<String> imageUrls,
    String? categoryId,
    String? digitalFileUrl,
    String? sku,
    int? inventoryQuantity,
    bool? manageInventory,
  }) async {
    try {
      await _client.post('/store/vendors/me/products', data: {
        'title': title,
        'description': description ?? '',
        'product_type': productType,
        'image_urls': imageUrls,
        if (categoryId != null) 'category_id': categoryId,
        if (digitalFileUrl != null && digitalFileUrl.isNotEmpty)
          'digital_file_url': digitalFileUrl,
        'variants': [
          {
            'title': 'Default',
            'prices': [{'amount': price, 'currency_code': 'ils'}],
            if (sku != null && sku.isNotEmpty) 'sku': sku,
            if (manageInventory != null) 'manage_inventory': manageInventory,
            if (inventoryQuantity != null) 'inventory_quantity': inventoryQuantity,
          }
        ],
      });
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _client.delete('/store/vendors/me/products/$productId');
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  Future<Map<String, dynamic>> importProducts(File file) async {
    try {
      final formData = FormData();
      formData.files.add(MapEntry(
        'file',
        await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      ));
      final res = await _client.post(
        '/store/custom/vendor/products/import',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  Future<List<int>> exportProducts() async {
    try {
      final res = await _client.get(
        '/store/custom/vendor/products/export',
        options: Options(responseType: ResponseType.bytes),
      );
      return res.data as List<int>;
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  // ─── Finances ───────────────────────────────────────────────────────────────

  Future<VendorBalance> getBalance() async {
    try {
      final res = await _client.get('/store/vendors/me/balance');
      return VendorBalance.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  Future<PayoutRequest> requestPayout(double amount) async {
    try {
      final res = await _client.post('/store/vendors/me/payout', data: {'amount': amount});
      return PayoutRequest.fromJson(res.data['payout'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  // ─── Q&A ────────────────────────────────────────────────────────────────────

  Future<List<VendorQuestion>> getQuestions() async {
    try {
      final res = await _client.get('/store/vendors/me/questions');
      final list = res.data['questions'] as List<dynamic>? ?? [];
      return list.map((e) => VendorQuestion.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  Future<void> answerQuestion(String questionId, String answer) async {
    try {
      // POST /store/vendors/me/questions/:id/answer with { answer }
      await _client.post('/store/vendors/me/questions/$questionId/answer', data: {'answer': answer});
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  Future<void> toggleQuestionVisibility(String questionId, {required bool isPublic}) async {
    try {
      await _client.patch('/store/vendors/me/questions/$questionId', data: {'is_public': isPublic});
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  // ─── Policies ───────────────────────────────────────────────────────────────

  Future<VendorPolicy?> getPolicy() async {
    try {
      final res = await _client.get('/store/vendors/me/policy');
      final policy = res.data['policy'];
      if (policy == null) return null;
      return VendorPolicy.fromJson(policy as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  Future<VendorPolicy> savePolicy({
    required String shippingPolicy,
    required String refundPolicy,
    required String returnPolicy,
    required String privacyPolicy,
    required String termsOfUse,
  }) async {
    try {
      final res = await _client.post('/store/vendors/me/policy', data: {
        'shipping_policy': shippingPolicy,
        'refund_policy': refundPolicy,
        'return_policy': returnPolicy,
        'privacy_policy': privacyPolicy,
        'terms_of_use': termsOfUse,
      });
      return VendorPolicy.fromJson(res.data['policy'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  // ─── Disputes ───────────────────────────────────────────────────────────────

  Future<void> respondToDispute(String disputeId, String response) async {
    try {
      await _client.post('/store/vendors/me/disputes/$disputeId/respond',
          data: {'vendor_response': response});
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  // ─── Settings ───────────────────────────────────────────────────────────────

  Future<VendorSettings> getVendorSettings() async {
    try {
      final res = await _client.get('/store/vendors/me');
      final vendor = res.data['vendor'] as Map<String, dynamic>?;
      if (vendor == null) throw AppException(message: 'No vendor found', statusCode: 404);
      return VendorSettings.fromJson(vendor);
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  Future<VendorSettings> updateSettings({
    String? storeName,
    String? description,
    String? email,
    String? phone,
    String? payoutAccountId,
    String? slug,
    File? logoFile,
    File? bannerFile,
  }) async {
    try {
      // Use multipart only when uploading images, otherwise JSON
      if (logoFile != null || bannerFile != null) {
        final form = FormData();
        if (storeName != null) form.fields.add(MapEntry('store_name', storeName));
        if (description != null) form.fields.add(MapEntry('description', description));
        if (email != null) form.fields.add(MapEntry('email', email));
        if (phone != null) form.fields.add(MapEntry('phone', phone));
        if (payoutAccountId != null) form.fields.add(MapEntry('payout_account_id', payoutAccountId));
        if (logoFile != null) {
          form.files.add(MapEntry('logo',
              await MultipartFile.fromFile(logoFile.path, filename: logoFile.path.split('/').last)));
        }
        if (bannerFile != null) {
          form.files.add(MapEntry('banner',
              await MultipartFile.fromFile(bannerFile.path, filename: bannerFile.path.split('/').last)));
        }
        final res = await _client.post('/store/vendors/me', data: form,
            options: Options(contentType: 'multipart/form-data'));
        return VendorSettings.fromJson(res.data['vendor'] as Map<String, dynamic>);
      } else {
        // Text-only update: use PUT /store/vendors/me/settings
        final res = await _client.put('/store/vendors/me/settings', data: {
          if (storeName != null) 'store_name': storeName,
          if (description != null) 'description': description,
          if (email != null) 'email': email,
          if (phone != null) 'phone': phone,
          if (payoutAccountId != null) 'payout_account_id': payoutAccountId,
          if (slug != null) 'slug': slug,
        });
        // settings PUT returns { vendor: [...] } array
        final vendorData = res.data['vendor'];
        final vendor = vendorData is List ? vendorData.first : vendorData;
        return VendorSettings.fromJson(vendor as Map<String, dynamic>);
      }
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  // ─── Helper ─────────────────────────────────────────────────────────────────

  AppException _wrap(DioException e) {
    final msg = (e.response?.data is Map)
        ? (e.response?.data as Map)['message']?.toString()
        : null;
    return AppException(
      message: msg ?? e.message ?? 'Request failed',
      statusCode: e.response?.statusCode,
      endpoint: e.requestOptions.path,
    );
  }
}
