import 'package:flutter_test/flutter_test.dart';
import 'package:laravel_rest_api_flutter/data/core/http_client/rest_api_http_client.dart';
import 'package:laravel_rest_api_flutter/data/core/rest_api_factories/laravel_rest_api/laravel_rest_api_delete_factory.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'mock/item_model.dart';
import 'mock/mock_http_client.dart';
import 'mock/mock_http_client.mocks.dart';

class ItemRepository with DeleteFactory<ItemModel> {
  MockDio mockDio;
  ItemRepository(this.mockDio);

  @override
  String get baseRoute => '/items';

  @override
  RestApiClient get httpClient => MockApiHttpClient(dio: mockDio);

  @override
  ItemModel fromJson(Map<String, dynamic> item) => ItemModel.fromJson(item);
}

void main() {
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
  });

  group('Delete Factory Tests', () {
    test('[200] Successful API call with valid JSON', () async {
      when(
        mockDio.delete(
          '/items',
          data: {
            "resources": [5, 6],
          },
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: {
            "data": [
              {"id": 5, "name": "Axe"},
              {"id": 6, "name": "Hammer"},
            ],
          },
        ),
      );

      final result = await ItemRepository(mockDio).delete(resourceIds: [5, 6]);

      expect(result.data?.length, 2);
    });

    test('[500] With common laravel error message', () async {
      when(
        mockDio.delete(
          '/items',
          data: {
            "resources": [5, 6],
          },
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 500,
          data: {
            "message": "Server error",
            "exception":
                "Symfony\\Component\\HttpKernel\\Exception\\NotFoundHttpException",
            "file":
                "/path/to/project/vendor/symfony/http-kernel/Exception/NotFoundHttpException.php",
            "line": 23,
          },
        ),
      );

      final result = await ItemRepository(mockDio).delete(resourceIds: [5, 6]);

      expect(result.statusCode, 500);
      expect(result.message, "Server error");
    });
  });
}
