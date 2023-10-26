import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
      birth = (DateTime.now().year - DateFormat("yyyy-MM-dd").parse(result.first['birth']).year + 1).toString();
    }
  }

  void setMember(TextEditingController nameController, TextEditingController heightController, TextEditingController weightController, TextEditingController dateController) async{
    final db = await DatabaseInit().initDB();
    bool frontData = false;

    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM Member WHERE id = 1"
    );

    if(result.isEmpty) {
      await db.rawQuery("INSERT INTO Member (name, height, weight, birth)"
          " VALUES ('${nameController.text}', ${int.parse(heightController.text)}, ${int.parse(weightController.text)}, ${heightController.text})");
    } else {
      String query = "UPDATE Member SET ";

      if(nameController.text.isNotEmpty) {
        query += "name='${nameController.text}'";
        frontData = true;
        name = nameController.text;
      }
      if(heightController.text.isNotEmpty) {
        query += "${frontData ? " ," : ""}height=${heightController.text}";
        frontData = true;
        height = int.parse(heightController.text);
      }
      if(weightController.text.isNotEmpty) {
        query += "${frontData ? " ," : ""}weight=${weightController.text}";
        frontData = true;
        weight = int.parse(weightController.text);
      }

      if(dateController.text.isNotEmpty) {
        query += "${frontData ? " ," : ""}birth='${dateController.text}'";
        birth = (DateTime.now().year - DateFormat("yyyy-MM-dd").parse(dateController.text).year + 1).toString();
      }
      print(query);
      await db.rawQuery(query + " WHERE id = 1");
    }

    update();
  }
}