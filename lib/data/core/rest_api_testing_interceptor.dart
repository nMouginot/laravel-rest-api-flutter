import 'package:dio/dio.dart';

class RestApiTestingInterceptor extends Interceptor {
  RestApiTestingInterceptor();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // await dotenv.load(fileName: ".env/.env.testing");
    // options.headers["Authorization"] = dotenv.env['TESTING_JWT'];
    return super.onRequest(options, handler);
  }
}
