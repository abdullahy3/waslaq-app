// lib/features/account/data/repositories/dispute_repository.dart

import 'package:dio/dio.dart';
import '../models/dispute_model.dart';
import '../../../../core/error/app_exception.dart';

class DisputeRepository {
  final Dio _client;
  DisputeRepository(this._client);

  Future<List<DisputeModel>> getMyDisputes() async {
    try {
      final res = await _client.get('/store/disputes');
      final list = (res.data['disputes'] as List<dynamic>? ?? []);
      return list.map((e) => DisputeModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _err(e);
    }
  }

  Future<({DisputeModel dispute, List<DisputeMessageModel> messages})> getDisputeDetails(String disputeId) async {
    try {
      final res = await _client.get('/store/disputes/$disputeId');
      final data = res.data as Map<String, dynamic>;
      final dispute = DisputeModel.fromJson(data['dispute'] as Map<String, dynamic>);
      final msgs = ((data['messages'] as List<dynamic>?) ?? [])
          .map((e) => DisputeMessageModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return (dispute: dispute, messages: msgs);
    } on DioException catch (e) {
      throw _err(e);
    }
  }

  Future<void> sendMessage(String disputeId, String message, {String? mediaUrl, String? mediaType}) async {
    try {
      await _client.post(
        '/store/disputes/$disputeId/message',
        data: {
          'message': message,
          if (mediaUrl != null) 'mediaUrl': mediaUrl,
          if (mediaType != null) 'mediaType': mediaType,
        },
      );
    } on DioException catch (e) {
      throw _err(e);
    }
  }

  Future<({String url, String mediaType})> uploadAttachment(String disputeId, String filePath) async {
    try {
      final fileName = filePath.split('/').last;
      final formData = FormData.fromMap({
        'files': await MultipartFile.fromFile(filePath, filename: fileName),
      });
      final res = await _client.post(
        '/store/disputes/$disputeId/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      final data = res.data as Map<String, dynamic>;
      if (data['success'] == true) {
        return (
          url: data['url'] as String,
          mediaType: data['mediaType'] as String,
        );
      } else {
        throw AppException(message: data['message']?.toString() ?? 'Upload failed');
      }
    } on DioException catch (e) {
      throw _err(e);
    }
  }

  Future<DisputeModel> openDispute({
    required String orderId,
    required String orderItemId,
    required String disputeType,
    required String description,
  }) async {
    try {
      final res = await _client.post('/store/disputes', data: {
        'order_id': orderId,
        'order_item_id': orderItemId,
        'dispute_type': disputeType,
        'description': description,
      });
      return DisputeModel.fromJson(res.data['dispute'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _err(e);
    }
  }

  AppException _err(DioException e) {
    if (e.error is AppException) return e.error as AppException;
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
