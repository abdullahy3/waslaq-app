// lib/features/account/data/repositories/account_repository.dart

import 'package:dio/dio.dart';
import '../models/order_model.dart';
import '../models/saved_item_model.dart';
import '../models/address_model.dart';
import '../../../../core/error/app_exception.dart';

class AccountRepository {
  final Dio _client;
  AccountRepository(this._client);

  // ─── Orders ─────────────────────────────────────────────────────────────────

  Future<List<OrderModel>> getOrders() async {
    try {
      // Uses /store/custom/orders which joins vendor_sub_order.status
      // so fulfillment_status correctly reflects shipped/pending instead
      // of always returning "not_fulfilled" from Medusa's native endpoint.
      final response = await _client.get('/store/custom/orders');
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

  // ─── Profile extended update ─────────────────────────────────────────────────
  Future<void> updateProfileExtended(
    String customerId, {
    String? displayName, String? bio, String? username,
    String? avatarStyle, String? avatarSeed, String? avatarUrl,
    String? bannerUrl, String? bannerColor, bool? isPrivate, bool? showActivityStatus,
    String? location, String? website, String? gender,
    List<String>? hobbies, Map<String, String>? socialLinks,
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
      if (bannerColor != null) data['bannerColor'] = bannerColor;
      if (isPrivate != null) data['isPrivate'] = isPrivate;
      if (showActivityStatus != null) data['showActivityStatus'] = showActivityStatus;
      if (location != null) data['location'] = location;
      if (website != null) data['website'] = website;
      if (gender != null) data['gender'] = gender;
      if (hobbies != null) data['hobbies'] = hobbies;
      if (socialLinks != null) data['socialLinks'] = socialLinks;
      await _client.patch('/store/social/profiles/$customerId', data: data);
    } on DioException catch (e) { throw _err(e); }
  }

  // ─── Username change ──────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> changeUsername(String username) async {
    try {
      final response = await _client.post('/store/social/username/change', data: {'username': username});
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) { throw _err(e); }
  }

  // ─── Follow requests ─────────────────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getFollowRequests() async {
    try {
      final response = await _client.get('/store/social/follow-requests');
      return List<Map<String, dynamic>>.from(response.data['requests'] ?? []);
    } on DioException catch (e) { throw _err(e); }
  }

  Future<void> approveFollowRequest(String requestId) async {
    try {
      await _client.post('/store/social/follow-requests/$requestId/approve');
    } on DioException catch (e) { throw _err(e); }
  }

  Future<void> rejectFollowRequest(String requestId) async {
    try {
      await _client.post('/store/social/follow-requests/$requestId/reject');
    } on DioException catch (e) { throw _err(e); }
  }

  // ─── Social settings ─────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getSocialSettings() async {
    try {
      final response = await _client.get('/store/social/settings');
      return response.data['settings'] as Map<String, dynamic>? ?? {};
    } on DioException catch (e) { throw _err(e); }
  }

  Future<void> updateSocialSettings(Map<String, dynamic> settings) async {
    try {
      await _client.patch('/store/social/settings', data: settings);
    } on DioException catch (e) { throw _err(e); }
  }

  // ─── Blocked users ────────────────────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getBlockedUsers() async {
    try {
      final response = await _client.get('/store/social/blocked');
      return List<Map<String, dynamic>>.from(response.data['blocked'] ?? []);
    } on DioException catch (e) { throw _err(e); }
  }

  Future<void> blockUser(String customerId) async {
    try {
      await _client.post('/store/social/blocked/$customerId');
    } on DioException catch (e) { throw _err(e); }
  }

  Future<void> unblockUser(String customerId) async {
    try {
      await _client.delete('/store/social/blocked/$customerId');
    } on DioException catch (e) { throw _err(e); }
  }

  // ─── Refund details ───────────────────────────────────────────────────────────
  Future<Map<String, dynamic>?> getRefundDetails() async {
    try {
      final response = await _client.get('/store/customers/me/refund-details');
      return response.data['refundDetails'] as Map<String, dynamic>?;
    } on DioException catch (e) { throw _err(e); }
  }

  Future<void> updateRefundDetails({String? fullName, String? bankName, String? iban, String? phone, String? preferredMethod}) async {
    try {
      await _client.patch('/store/customers/me/refund-details', data: {
        if (fullName != null) 'fullName': fullName,
        if (bankName != null) 'bankName': bankName,
        if (iban != null) 'iban': iban,
        if (phone != null) 'phone': phone,
        if (preferredMethod != null) 'preferredMethod': preferredMethod,
      });
    } on DioException catch (e) { throw _err(e); }
  }

  // ─── Address book ─────────────────────────────────────────────────────────────
  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await _client.get('/store/custom/addresses');
      final list = response.data['addresses'] as List<dynamic>? ?? [];
      return list.map((e) => AddressModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) { throw _err(e); }
  }

  Future<AddressModel> addAddress(Map<String, dynamic> data) async {
    try {
      final response = await _client.post('/store/custom/addresses', data: data);
      return AddressModel.fromJson(response.data['address'] as Map<String, dynamic>);
    } on DioException catch (e) { throw _err(e); }
  }

  Future<void> updateAddress(String addressId, Map<String, dynamic> data) async {
    try {
      await _client.patch('/store/custom/addresses/$addressId', data: data);
    } on DioException catch (e) { throw _err(e); }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      await _client.delete('/store/custom/addresses/$addressId');
    } on DioException catch (e) { throw _err(e); }
  }

  // ─── Delete account ───────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      final response = await _client.post('/store/custom/account/delete', data: {});
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) { throw _err(e); }
  }

  Future<void> cancelDeletion() async {
    try {
      await _client.post('/store/custom/account/cancel-deletion', data: {});
    } on DioException catch (e) { throw _err(e); }
  }

  // ─── Vendor vacation mode ─────────────────────────────────────────────────────
  Future<void> setVacationMode(bool enabled) async {
    try {
      await _client.patch('/store/vendors/me/vacation-mode', data: {'vacationMode': enabled});
    } on DioException catch (e) { throw _err(e); }
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
    if (e.error is AppException) {
      return e.error as AppException;
    }
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
