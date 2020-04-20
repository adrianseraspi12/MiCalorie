
typedef SuccessCallback<T> = Function(T);
typedef FailCallback = Function(String);

abstract class Repository<T> {

  void save(T data, SuccessCallback<T> successCallback, FailCallback failCallback);
  void update(T data, SuccessCallback<T> successCallback, FailCallback failCallback);
  Future<T> get<F>(F itemId);
  Future<List<T>> getListOfData();
  void remove(T data, SuccessCallback<T> successCallback, FailCallback failCallback);

}