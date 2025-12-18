abstract class ApiResult<T> {}

class ApiErrorResult<T> extends ApiResult<T> implements Exception {
  final int errorCode;
  final String originalErrorMessage;

  ApiErrorResult({
    required this.errorCode,
    required this.originalErrorMessage,
  });
}

class ApiDataResult<T> extends ApiResult<T> {
  final T data;

  ApiDataResult({required this.data});
}
