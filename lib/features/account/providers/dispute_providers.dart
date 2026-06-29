// lib/features/account/providers/dispute_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/medusa_client.dart';
import '../data/models/dispute_model.dart';
import '../data/repositories/dispute_repository.dart';

final disputeRepositoryProvider = Provider<DisputeRepository>((ref) {
  return DisputeRepository(MedusaClient.instance);
});

/// All disputes for the current buyer.
final myDisputesProvider = FutureProvider<List<DisputeModel>>((ref) {
  return ref.watch(disputeRepositoryProvider).getMyDisputes();
});

/// Single dispute with its messages — takes dispute ID.
final disputeDetailProvider = FutureProvider.family<
    ({DisputeModel dispute, List<DisputeMessageModel> messages}),
    String>((ref, disputeId) {
  return ref.watch(disputeRepositoryProvider).getDisputeDetails(disputeId);
});
