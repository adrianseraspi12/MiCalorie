
typedef SuccessCallback<T> = Function(T);
typedef FailCallback = Function(String);

abstract class Repository<T> {

  void save(T data, SuccessCallback<T> successCallback, FailCallback failCallback);
  void update(T data, SuccessCallback<T> successCallback, FailCallback failCallback);
  void get(int itemId, SuccessCallback<T> successCallback, FailCallback failCallback);
  void getListOfData(SuccessCallback<List<T>> successCallback, FailCallback failCallback);
  void remove(T data, SuccessCallback<T> successCallback, FailCallback failCallback);

}