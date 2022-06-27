abstract class BaseParser<T> {
  Future<T> parse(String response);
}
