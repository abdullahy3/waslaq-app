// lib/features/account/data/repositories/account_repository.dart

import 'package:dio/dio.dart';
import '../models/order_model.dart';
import '../models/saved_item_model.dart';
import '../../../../core/error/app_exception.dart';

class AccountRepository {
  final Dio _client;
  AccountRepository(this._client);

  // ─── Orders ─────────────────────────────────────────────────────────────────

  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await _client.get(
        '/store/orders',
        queryParameters: {
          'fields':
              'id,display_id,status,payment_status,fulfillment_status,total,currency_code,created_at,items.*,items.thumbnail',
          'order': '-created_at',
          'limit': 50,
        },
      );
      final raw = response.data;
      final List<dynamic> list = raw is Map && raw.containsKey('orders')
          ? raw['orders'] as List<dynamic>
          : raw is List
              ? raw
              : [];
      return list
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _err(e);
    }
  }

  Future<OrderModel> getOrder(String orderId) async {
    try {
      final response = await _client.get(
        '/store/orders/$orderId',
        queryParameters: {
          'fields':
              'id,display_id,status,payment_status,fulfillment_status,total,currency_code,created_at,items.*,items.thumbnail,shipping_address.*',
        },
      );
      final raw = response.data;
      final Map<String, dynamic> orderJson =
          raw is Map && raw.containsKey('order')
              ? raw['order'] as Map<String, dynamic>
              : raw as Map<String, dynamic>;
      return OrderModel.fromJson(orderJson);
    } on DioException catch (e) {
      throw _err(e);
    }
  }

  // ─── Saved Items ─────────────────────────────────────────────────────────────

  Future<SavedItemsModel> getSavedItems() async {
    try {
      final response = await _client.get('/store/social/saved');
      return SavedItemsModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _err(e);
    }
  }

  /// Returns the new saved state: true = now saved, false = now unsaved.
  Future<bool> toggleSave(String itemType, String itemId) async {
    try {
      final response = await _client.post(
        '/store/social/saved',
        data: {'itemType': itemType, 'itemId': itemId},
      );
      return response.data['saved'] as bool? ?? false;
    } on DioException catch (e) {
      throw _err(e);
    }
  }

  // ─── Profile update ──────────────────────────────────────────────────────────

  Future<void> updateProfile(
    String customerId, {
    String? displayName,
    String? bio,
    String? username,
    String? avatarStyle,
    String? avatarSeed,
    String? avatarUrl,
    String? bannerUrl,
    bool? isPrivate,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (displayName != null) data['displayName'] = displayName;
      if (bio != null) data['bio'] = bio;
      if (username != null) data['username'] = username;
      if (avatarStyle != null) data['avatarStyle'] = avatarStyle;
      if (avatarSeed != null) data['avatarSeed'] = avatarSeed;
      if (avatarUrl != null) data['avatarUrl'] = avatarUrl;
      if (bannerUrl != null) data['bannerUrl'] = bannerUrl;
      if (isPrivate != null) data['isPrivate'] = isPrivate;
      await _client.patch(
          '/store/social/profiles/$customerId', data: data);
    } on DioException catch (e) {
      throw _err(e);
    }
  }

  // ─── Become a vendor ─────────────────────────────────────────────────────────

  Future<void> applyAsVendor({
    required String storeName,
    String? description,
    String? phone,
    String? location,
  }) async {
    try {
      await _client.post('/store/vendors', data: {
        'store_name': storeName,
        if (description != null && description.isNotEmpty)
          'description': description,
      });
    } on DioException catch (e) {
      throw _err(e);
    }
  }

  // ─── Error helper ────────────────────────────────────────────────────────────

  AppException _err(DioException e) {
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
