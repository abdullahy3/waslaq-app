// lib/features/account/providers/account_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/medusa_client.dart';
import '../data/models/order_model.dart';
import '../data/models/saved_item_model.dart';
import '../data/repositories/account_repository.dart';

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepository(MedusaClient.instance);
});

/// All customer orders, newest first.
final ordersProvider = FutureProvider<List<OrderModel>>((ref) {
  return ref.watch(accountRepositoryProvider).getOrders();
});

/// Single order by ID.
final orderDetailProvider =
    FutureProvider.family<OrderModel, String>((ref, orderId) {
  return ref.watch(accountRepositoryProvider).getOrder(orderId);
});

/// Saved items (products + posts) for the current user.
final savedItemsProvider = FutureProvider<SavedItemsModel>((ref) {
  return ref.watch(accountRepositoryProvider).getSavedItems();
});
