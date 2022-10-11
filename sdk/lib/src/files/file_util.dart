import 'dart:io';

bool deleteDir(String path, {recursive: false}) {
  if (File(path).existsSync()) {
    throw Exception("This is a file path not a directory path");
  }
  var directory = Directory(path);
  try {
    directory.delete(recursive: recursive);
    return true;
  } catch (error) {
    throw Exception(error.toString());
  }
}