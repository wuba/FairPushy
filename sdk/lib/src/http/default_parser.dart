import 'abstract_parser.dart';

class DefaultParser extends BaseParser<String> {
  @override
  Future<String> parse(String response) async {
    return response.toString();
  }
}
