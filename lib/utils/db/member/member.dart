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
        "SELECT * FROM Member ORDER BY id DESC LIMIT 1");

    if(result.first.isNotEmpty) {
      name = result.first['name'].toString();
      height = result.first['height'] as int;
      weight = result.first['weight'] as int ;
      birth = (DateTime.now().year - DateFormat("yyyy-MM-dd").parse(result.first['birth']).year + 1).toString();
    }
    update();
  }

  void setMember(TextEditingController nameController, TextEditingController heightController, TextEditingController weightController, TextEditingController dateController) async{
    final db = await DatabaseInit().initDB();
    bool frontData = false;

    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM Member ORDER BY id DESC LIMIT 1"
    );

    if(result.isEmpty) {
      String query1 = "INSERT INTO Member (";
      String query2 = " VALUES (";

      if(nameController.text.isNotEmpty) {
        query1 += "name";
        query2 += "'${nameController.text}'";
        frontData = true;
        name = nameController.text;
      }

      if(heightController.text.isNotEmpty) {
        if(frontData) {
          query1 += " ,";
          query2 += " ,";
        }
        query1 += "height";
        query2 += "${heightController.text}";
        frontData = true;
        height = int.parse(heightController.text);
      }
      if(weightController.text.isNotEmpty) {
        if(frontData) {
          query1 += " ,";
          query2 += " ,";
        }
        query1 += "weight";
        query2 += "${weightController.text}";
        frontData = true;
        weight = int.parse(weightController.text);
      }

      if(dateController.text.isNotEmpty) {
        if(frontData) {
          query1 += " ,";
          query2 += " ,";
        }
        query1 += "birth";
        query2 += "'${dateController.text}'";
        birth = (DateTime.now().year - DateFormat("yyyy-MM-dd").parse(dateController.text).year + 1).toString();
      }
      query1 += ")";
      query2 += ")";
      print(query1 + query2);
      await db.rawQuery(query1+ query2);

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
      await db.rawQuery(query + " WHERE id=(SELECT id FROM Member ORDER BY id DESC LIMIT 1)");
    }

    update();
  }
}