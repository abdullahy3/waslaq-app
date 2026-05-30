// lib/features/vendor/providers/vendor_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/medusa_client.dart';
import '../data/models/vendor_dashboard_model.dart';
import '../data/repositories/vendor_repository.dart';

part 'vendor_providers.g.dart';

/// Whether the current user is a vendor.
@riverpod
Future<bool> isVendor(Ref ref) async {
  try {
    final res = await MedusaClient.instance.get('/store/vendors/me');
    return res.data['is_vendor'] == true;
  } catch (_) {
    return false;
  }
}

final vendorRepositoryProvider = Provider<VendorRepository>((ref) {
  return VendorRepository(MedusaClient.instance);
});

// Overview
final vendorDashboardProvider = FutureProvider<VendorDashboardModel>((ref) {
  return ref.watch(vendorRepositoryProvider).getDashboard();
});

// Orders
final vendorOrdersProvider = FutureProvider<List<VendorOrder>>((ref) {
  return ref.watch(vendorRepositoryProvider).getOrders();
});

// Products
final vendorProductsProvider = FutureProvider<List<VendorProduct>>((ref) {
  return ref.watch(vendorRepositoryProvider).getProducts();
});

// Categories (for create product form)
final vendorCategoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final res = await MedusaClient.instance.get(
      '/store/product-categories',
      queryParameters: {'limit': 100, 'include_descendants_tree': true},
    );
    final cats = res.data['product_categories'] as List<dynamic>? ?? [];
    return cats.map((c) => c as Map<String, dynamic>).toList();
  } catch (_) {
    return [];
  }
});

// Finances
final vendorBalanceProvider = FutureProvider<VendorBalance>((ref) {
  return ref.watch(vendorRepositoryProvider).getBalance();
});

// Q&A
final vendorQuestionsProvider = FutureProvider<List<VendorQuestion>>((ref) {
  return ref.watch(vendorRepositoryProvider).getQuestions();
});

// Policies
final vendorPolicyProvider = FutureProvider<VendorPolicy?>((ref) {
  return ref.watch(vendorRepositoryProvider).getPolicy();
});

// Settings
final vendorSettingsProvider = FutureProvider<VendorSettings>((ref) {
  return ref.watch(vendorRepositoryProvider).getVendorSettings();
});
