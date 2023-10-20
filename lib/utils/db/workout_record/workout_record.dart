class WorkoutRecord {
  int? id;
  String? dateTime = DateTime.now.toString();
  int? useTime = 0;
  int? count = 0;

  WorkoutRecord({this.id, this.dateTime, this.useTime, this.count});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime,
      'useTime' : useTime,
      'count' : count
    };
  }

}