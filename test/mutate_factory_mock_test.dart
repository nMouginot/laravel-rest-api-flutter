import 'package:flutter_test/flutter_test.dart';
import 'package:laravel_rest_api_flutter/data/core/http_client/rest_api_http_client.dart';
import 'package:laravel_rest_api_flutter/data/core/models/laravel_rest_api/body/laravel_rest_api_mutate_body.dart';
import 'package:laravel_rest_api_flutter/data/core/rest_api_factories/laravel_rest_api/laravel_rest_api_mutate_factory.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'mock/item_model.dart';
import 'mock/mock_http_client.dart';
import 'mock/mock_http_client.mocks.dart';

class ItemRepository with MutateFactory<ItemModel> {
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

  group('Mutate Factory Tests', () {
    test('[200] Successful API call with valid JSON', () async {
      when(
        mockDio.post(
          '/items/mutate',
          data: {
            "mutate": [
              {
                "operation": "create",
                "attributes": ItemModel(id: 1, name: "name").toJson(),
              },
            ],
          },
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: {
            "created": [1],
            "updated": [],
          },
        ),
      );

      final result = await ItemRepository(mockDio).mutate(
        body: LaravelRestApiMutateBody(
          mutate: [
            Mutation(
              operation: MutationOperation.create,
              attributes: ItemModel(id: 1, name: "name").toJson(),
            ),
          ],
        ),
      );

      expect(result.statusCode, 200);
      expect(result.data, isNotNull);
      expect(result.data?.created.contains(1), true);
      expect(result.data?.updated.isEmpty, true);
    });

    test('[500] With common laravel error message', () async {
      when(
        mockDio.post(
          '/items/mutate',
          data: {
            "mutate": [
              {
                "operation": "create",
                "attributes": ItemModel(id: 1, name: "name").toJson(),
              },
            ],
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

      final result = await ItemRepository(mockDio).mutate(
        body: LaravelRestApiMutateBody(
          mutate: [
            Mutation(
              operation: MutationOperation.create,
              attributes: ItemModel(id: 1, name: "name").toJson(),
            ),
          ],
        ),
      );

      expect(result.statusCode, 500);
      expect(result.message, "Server error");
    });
  });
  test('[500] With custom object error message returned', () async {
    when(
      mockDio.post(
        '/items/mutate',
        data: {
          "mutate": [
            {
              "operation": "create",
              "attributes": ItemModel(id: 1, name: "name").toJson(),
            },
          ],
        },
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(),
        statusCode: 500,
        data: {"error": "error"},
      ),
    );

    final result = await ItemRepository(mockDio).mutate(
      body: LaravelRestApiMutateBody(
        mutate: [
          Mutation(
            operation: MutationOperation.create,
            attributes: ItemModel(id: 1, name: "name").toJson(),
          ),
        ],
      ),
    );

    expect(result.statusCode, 500);
    expect(result.body["error"], "error");
  });
}
