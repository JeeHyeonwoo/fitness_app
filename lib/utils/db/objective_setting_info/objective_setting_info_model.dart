class ObjectiveSettingInfo {
  int? id;
  int? timer;   // 설정 시간
  int? count;   // 설정 횟수

  ObjectiveSettingInfo({this.id, this.count, this.timer});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timer': timer,
      'count': count
    };
  }
}