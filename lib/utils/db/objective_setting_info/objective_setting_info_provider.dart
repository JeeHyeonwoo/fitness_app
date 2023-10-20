import 'package:sqflite/sqflite.dart';

import 'objective_setting_info_model.dart';

class ObjectiveSettingInfoProvider {
  late Database _database;

  ObjectiveSettingInfoProvider({required Database database}) : _database = database;


  // 검색
  Future<List<ObjectiveSettingInfo>> findOne() async{
    final db = await _database;
    String query = "select * From ObjectiveSettingInfo where id=0";
    final List<Map<String, dynamic>> maps = await db!.rawQuery(query);
    if(maps.isEmpty) return [
      ObjectiveSettingInfo(
        timer: 15 * 60, // 15분
        count: 50
      )
    ];
    List<ObjectiveSettingInfo> list = List.generate(maps.length, (index) {
      return ObjectiveSettingInfo(
        id: maps[index]['id'],
        timer: maps[index]['timer'],
        count: maps[index]['count']
      );
    });
    return list;
  }

  // 업데이트
  Future<void> update(ObjectiveSettingInfo info) async{
    try {
      await _database.rawUpdate("UPDATE ObjectiveSettingInfo SET timer=${info.timer}, count=${info.count} WHERE id=0");
    }catch(e) {
      info.id = 0;
      _database.insert('ObjectiveSettingInfo', info.toMap());

    }
  }
}