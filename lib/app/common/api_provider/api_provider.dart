import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:evolution/app/common/api_provider/api_urls.dart';
import 'package:evolution/app/common/enums/error_from.dart';
import 'package:evolution/app/common/models/custom_error_model.dart';
import 'package:evolution/app/common/utils/type_def.dart';

class ApiProvider {
  static final ApiProvider _instance = ApiProvider._internal();
  final Dio _dio = Dio();

  ApiProvider._internal() {

    _dio.options.baseUrl = ApiUrls.baseApiUrl;
    _dio.options.headers['Content-Type'] = 'application/json';

    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 5);
    _dio.options.sendTimeout = const Duration(seconds: 5);

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {

        /* if (StorageHelper.hasUserToken) {
          options.headers['Authorization'] = "Bearer ${StorageHelper.getToken}";
        }*/
        return handler.next(options);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) {
        final String errorMessage = _handleError(error);
        handler.reject(DioException(
          requestOptions: error.requestOptions,
          error: errorMessage,
          response: error.response,
        ));
      },
    ));
  }

  factory ApiProvider() {
    return _instance;
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final errorData = error.response!.data;
      // Handle specific error cases here
      switch (statusCode) {
        case 400:
          return "Bad Request: $errorData";
        case 401:
          return "Unauthorized: $errorData";
        case 404:
          return "Not Found: $errorData";
        default:
          return "An error occurred: $statusCode";
      }
    } else {
      return "Connection Error";
    }
  }

  Either<CustomErrorModel, T> _convert<T>({
    required Response<dynamic>? response,
    required T Function(Map<String, dynamic>) base,
    bool onlyErrorCheck = false,
  }) {
    if (response == null) {
      return left(CustomErrorModel(
        errorCode: -1,
        errorFrom: ErrorFrom.noInternet,
        msg: "No response received",
      ));
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final data = base(response.data as Map<String, dynamic>);
        return right(data);
      } catch (e) {
        return left(CustomErrorModel(
          errorCode: -1,
          errorFrom: ErrorFrom.typeConversion,
          msg: "Error parsing response data",
        ));
      }
    } else {
      return left(CustomErrorModel(
        errorCode: response.statusCode ?? -1,
        errorFrom: ErrorFrom.api, // You can specify the source of the error here
        msg: "HTTP error ${response.statusCode}",
      ));
    }
  }

  EitherModel<T> get<T>({required String url, required T Function(Map<String, dynamic>) fromJson}) async {
    final Response response = await _dio.get(url);
    return _convert(response: response, base: fromJson);
  }

  EitherModel<T> post<T>(
      {required String url, required Object requestBody, required T Function(Map<String, dynamic>) fromJson}) async {
    final Response response = await _dio.post(url, data: requestBody);
    return _convert(response: response, base: fromJson);
  }

  EitherModel<T> put<T>(
      {required String url, required Object requestBody, required T Function(Map<String, dynamic>) fromJson}) async {
    final Response response = await _dio.put(url, data: requestBody);
    return _convert(response: response, base: fromJson);
  }

  EitherModel<T> delete<T>(
      {required String url, required Object requestBody, required T Function(Map<String, dynamic>) fromJson}) async {
    final Response response = await _dio.delete(url);
    return _convert(response: response, base: fromJson);
  }
}
