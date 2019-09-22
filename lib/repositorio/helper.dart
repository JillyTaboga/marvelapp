import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;

class Helper {

  static String generateMd5(data) {
      var content = new Utf8Encoder().convert(data);
      var md5 = crypto.md5;
      var digest = md5.convert(content);
      return hex.encode(digest.bytes);
  }
}

