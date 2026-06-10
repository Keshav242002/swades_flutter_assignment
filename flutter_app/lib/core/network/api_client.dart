import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/api_constants.dart';
import 'api_exceptions.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final token = await user.getIdToken();
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        handler.reject(_transformError(error));
      },
    ));
  }

  DioException _transformError(DioException error) {
    ApiException? apiException;

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.unknown) {
      apiException = const NetworkException();
    } else if (error.response != null) {
      switch (error.response!.statusCode) {
        case 401:
          apiException = const UnauthorizedException();
          break;
        case 403:
          apiException = const ForbiddenException();
          break;
        case 404:
          apiException = const NotFoundException('Resource not found.');
          break;
        case 409:
          apiException = const SlotAlreadyBookedException();
          break;
        default:
          final msg = error.response?.data?['detail'] ??
              error.response?.data?['message'] ??
              'Something went wrong.';
          apiException = ApiException(msg.toString(),
              statusCode: error.response!.statusCode);
      }
    } else {
      apiException = const NetworkException();
    }

    return DioException(
      requestOptions: error.requestOptions,
      error: apiException,
      message: apiException.message,
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.get(path, queryParameters: queryParams);
    } on DioException catch (e) {
      throw e.error ?? ApiException(e.message ?? 'Unknown error');
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw e.error ?? ApiException(e.message ?? 'Unknown error');
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      throw e.error ?? ApiException(e.message ?? 'Unknown error');
    }
  }
}
