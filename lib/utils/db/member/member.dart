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

  void setMember(TextEditingController nameController, TextEditingController heightController, TextEditingController weightController, TextEditingController dateController) async{
    final db = await DatabaseInit().initDB();
    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM Member WHERE id = 1"
    );

    print("result: ${result}");

    if(result.isEmpty) {
      await db.rawQuery("INSERT INTO Member (name, height, weight, birth)"
          " VALUES ('${nameController.text}', ${int.parse(heightController.text)}, ${int.parse(weightController.text)}, ${heightController.text})");
    } else {
      String query = "UPDATE Member SET ";

      if(nameController.text.isNotEmpty) {
        query += "name='${nameController.text}'";
      }
      if(heightController.text.isNotEmpty) {
        query += " ,height=${heightController.text}";
      }
      if(heightController.text.isNotEmpty) {
        query += " ,weight=${heightController.text}";
      }
      if(dateController.text.isNotEmpty) {
        query += " ,birth=${dateController.text}";
      }

      await db.rawQuery(query + " WHERE id = 1");
    }

    name = nameController.text;
    weight = int.parse(weightController.text);
    height = int.parse(heightController.text);
    update();
  }
}