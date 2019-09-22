import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Database {

  static Future<File> getBase () async{
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/favorites.json");
  }

  static void saveData (var data) async {
    String jsonData = json.encode(data);
    final File file = await getBase();
    file.writeAsString(jsonData);
    print(jsonData);
  }

  static Future<String> readData () async {
    try{
      final File file = await getBase();
      if(await file.exists()) {
        print('aqui');
        String data = file.readAsStringSync();
        if(data == null){
          saveData("{[]}");
          String data = file.readAsStringSync();
        }
        return  data;
      }else{
        saveData("{[]}");
      }
    } catch (e){
      print(e);
    }
  }

}