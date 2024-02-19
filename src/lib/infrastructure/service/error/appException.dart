class AppException implements Exception {
  final String _result;
  final String _message;

  AppException([this._message = "", this._result = ""]);

  @override
  String toString() {
    return "$_result, $_message";
  }

  String get code => _result;
  String get message => _message;
}

class FetchDataException extends AppException {
  FetchDataException(message) : super(message);
}

class InternalServerException extends AppException {
  InternalServerException(message) : super(message);
}
