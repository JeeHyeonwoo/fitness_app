import 'package:flutter/cupertino.dart';

class CountingController with ChangeNotifier {
  int _count = 50;
  int get count => _count;

  void changeCount(int num) {
    _count = num;
    print(count.toString());
    notifyListeners();
  }

  Future<void> start() async{

  }
  void stop() async {

  }
  void reset() {

  }
}