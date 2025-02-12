import 'package:laravel_rest_api_flutter/data/core/http_client/rest_api_http_client.dart';
import 'package:laravel_rest_api_flutter/data/core/models/laravel_rest_api/body/laravel_rest_api_mutate_body.dart';
import 'package:laravel_rest_api_flutter/data/core/models/laravel_rest_api/response/laravel_rest_api_mutate_reponse.dart';
import '../../rest_api_repository.dart';

/// A mixin to simplify building search requests for Laravel Rest API.
mixin MutateFactory<T> {
  /// The base route for the resource (e.g., '/posts').
  String get baseRoute;

  /// The HTTP client used to send requests. Typically a http or Dio instance.
  RestApiClient get httpClient;

  /// Converts a JSON response into an instance of type `T`.
  T fromJson(Map<String, dynamic> json);

  Future<RestApiResponse<LaravelRestApiMutateResponse>> mutate({
    required LaravelRestApiMutateBody body,
  }) async {
    // Sending the request using a REST API client.
    final response = await handlingResponse(
      '$baseRoute/mutate',
      apiMethod: ApiMethod.post,
      client: httpClient,
      body: body.toJson(),
    );

    if (response.body is Map &&
        response.body.containsKey("created") &&
        response.body.containsKey("updated")) {
      return RestApiResponse<LaravelRestApiMutateResponse>(
        body: response.body,
        data: LaravelRestApiMutateResponse(
          created: response.body["created"].map<int>((e) => e as int).toList(),
          updated: response.body["updated"].map<int>((e) => e as int).toList(),
        ),
        message: response.message,
        headers: response.headers,
        statusCode: response.statusCode,
      );
    }

    return RestApiResponse<LaravelRestApiMutateResponse>(
      body: response.body,
      headers: response.headers,
      message: response.message,
      statusCode: response.statusCode,
    );
  }
}
