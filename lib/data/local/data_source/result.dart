abstract class Result<T> {}

class Success<T> extends Result<T> {
  final T data;

  Success(this.data);
}

class Fail<T> extends Result<T> {
  final String message;

  Fail(this.message);
}
