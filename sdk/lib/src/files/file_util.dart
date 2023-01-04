import 'dart:io';

Future<bool> deleteDir(String path, {recursive: false}) async {
  if (File(path).existsSync()) {
    throw Exception("This is a file path not a directory path");
  }
  var directory = Directory(path);
  if (!directory.existsSync()) {
    return false;
  }
  try {
    await directory.delete(recursive: recursive);
    return true;
  } catch (error) {
    throw Exception(error.toString());
  }
}