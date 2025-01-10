class Result<T> {
  final T? data;
  final String? error;
  final bool isLoading;

  Result.success([this.data])
      : error = null,
        isLoading = false;

  Result.failure(this.error)
      : data = null,
        isLoading = false;

  Result.loading()
      : data = null,
        error = null,
        isLoading = true;

  bool get isSuccess => data != null && !isLoading;
  bool get isFailure => error != null && !isLoading;
}
