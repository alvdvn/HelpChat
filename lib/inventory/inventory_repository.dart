import 'package:dio/dio.dart';

import 'inventory_response.dart';

class InventoryRepository {
  final Dio _dio;

  InventoryRepository(Dio dio) : _dio = dio;

  Future<List<String>> fetchPets(int length, int size) async {
    const path = '/api/auth/inventory/pets';
    try {
      final params = {'length': length, 'size': size};
      final response = await _dio.get<Map>(path, queryParameters: params);
      final data = response.data;
      if (data == null) return <String>[];

      return InventoryResponse.fromJson(data).data;
    } catch (e) {
      rethrow;
    }
  }
}
