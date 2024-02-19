import 'package:dio/dio.dart';

// function to throw an exception
DioException resposeDioException(DioException e, String? path) {
 return DioException(
    requestOptions: RequestOptions(),
    response: Response(
      requestOptions: RequestOptions(path: path ?? ''),
      statusCode: e.response!.statusCode,
      statusMessage: e.response!.statusMessage,
    ),
  );
}
