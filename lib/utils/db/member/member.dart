import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../db_init.dart';

class Member extends GetxController{
  String? name;
  int? weight;
  int? height;
  String? birth;

  Member() {
    getMember();
  }

  void getMember() async{
    final _db = await DatabaseInit().initDB();
    List<Map<String, dynamic>> result = await _db.rawQuery(
        "SELECT * FROM Member WHERE id = 1");

    if(result.first.isNotEmpty) {
      name = result.first['name'].toString();
      height = result.first['height'] as int;
      weight = result.first['weight'] as int ;
      birth = result.first['birth'].toString();
    }
  }

  void setMember(TextEditingController nameController, TextEditingController heightController, TextEditingController weightController) async{
    final db = await DatabaseInit().initDB();
    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM Member WHERE id = 1"
    );

    print("result: ${result}");

    if(result.isEmpty) {
      await db.rawQuery("INSERT INTO Member (name, height, weight, birth)"
          " VALUES ('${nameController.text}', ${int.parse(heightController.text)}, ${int.parse(weightController.text)}, '19950228')");
    }else {
      await db.rawQuery("UPDATE Member SET name='${nameController.text}', height=${heightController.text}, weight=${weightController.text} WHERE id = 1");
    }

    name = nameController.text;
    weight = int.parse(weightController.text);
    height = int.parse(heightController.text);
    update();
  }
}