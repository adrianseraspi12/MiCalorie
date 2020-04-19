abstract class Repository<T> {

  void save(T data, Listener<T> listener);
  void update(T data, Listener<T> listener);
  void get(int itemId, Listener<T> listener);
  void getListOfData(Listener<List<T>> listener);
  void remove(T data, Listener<T> listener);

}

abstract class Listener<T> {

  void onSuccess(T data);
  void onFailed(String message);

}