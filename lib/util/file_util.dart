import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class FileUtil {
  static Future<String> get _localAppPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<String> get _tempDirPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  static Future<File> getAppFileHandle(String fileName) async {
    final path = await _localAppPath;
    return File('$path/$fileName');
  }

  static Future<File> getTempFileHandle(String fileName) async {
    final path = await _tempDirPath;
    return File('$path/$fileName');
  }

  static Future<String> getAppFileContents(String fileName) async {
      final file = await getAppFileHandle(fileName);
      return await file.readAsString();
  }

  static Future<String> getTempFileContents(String fileName) async {
    final file = await getTempFileHandle(fileName);
    return await file.readAsString();
  }

  static Future<File> writeAppFileContents(String fileName, String contents, {bool append = false, bool flush = false}) async {
    final file = await getAppFileHandle(fileName);
    FileMode fileMode = append ? FileMode.append : FileMode.write;
    Encoding encoding = utf8;
    return await file.writeAsString(contents, mode: fileMode, encoding: encoding, flush: flush);
  }

  static Future<File> writeTempFileContents(String fileName, String contents, {bool append = false, bool flush = false}) async {
    final file = await getTempFileHandle(fileName);
    FileMode fileMode = append ? FileMode.append : FileMode.write;
    Encoding encoding = utf8;
    return await file.writeAsString(contents, mode: fileMode, encoding: encoding, flush: flush);
  }

  static Future<String> loadAsset(BuildContext context, String assetPath) async {
    return await DefaultAssetBundle.of(context).loadString(assetPath);
  }
}
