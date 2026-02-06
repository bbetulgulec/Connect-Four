import 'package:connect_four/app/data/service/hive_service.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  void contunieGame() {
    final saveData = HiveService.getData("current_game");
    if (saveData == null) return;
  }
  void newGame(){
    HiveService.deleteData("current_game");
  }
}
