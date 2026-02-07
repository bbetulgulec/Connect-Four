import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String _boxName = 'game_data';

  static Future<void> init() async {
    await Hive.initFlutter();
    // Kutuyu açmayı unutma!
    await Hive.openBox(_boxName);
  }

  // Aktif Oyunu Kaydet
  static Future<void> saveActiveGame(Map<String, dynamic> data) async {
    var box = Hive.box(_boxName);
    await box.put('current_game', data);
  }

  // Genel Veri Kaydet
  static Future<void> saveData(String key, dynamic data) async {
    var box = Hive.box(_boxName);
    await box.put(key, data);
  }

  // Veri Oku
  static Map<String, dynamic>? getData(String key) {
    var box = Hive.box(_boxName);
    final data = box.get(key);
    if (data != null) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  // Sil
  static Future<void> deleteData(String key) async {
    var box = Hive.box(_boxName);
    await box.delete(key);
  }

  static Map<String, dynamic> getProgress() {
    final data = getData('game_progress');
    if (data != null) return data;

    // Eğer henüz kayıt yoksa varsayılan değerler
    return {'highScore': 0, 'lastScore': 0, 'coins': 0};
  }

  // Progress kaydetmek için yardımcı metod
  static Future<void> saveProgress(Map<String, dynamic> data) async {
    await saveData('game_progress', data);
  }

  // Aktif oyunu silmek için (Önceki kodunda deleteData vardı, isim uyumu için ekleyebilirsin)
  static Future<void> deleteActiveGame() async {
    await deleteData('current_game');
  }
}
