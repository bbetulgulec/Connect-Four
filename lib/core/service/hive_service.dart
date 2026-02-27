import 'package:connect_four/app/common/enum/action_mode.dart';
import 'package:connect_four/app/presentations/main/view/main_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String _boxName = 'game_data';
  static const String _boxSkill = 'game_skill';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
    await Hive.openBox(_boxSkill);
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
    if (data != null) return Map<String, dynamic>.from(data);

    // Eğer henüz kayıt yoksa varsayılan değerler
    return {'highScore': 0, 'lastScore': 0, 'coins': 0, 'currentLevel': 1};
  }

  // Mevcut Level'ı getirir
  static int getLevel() {
    final progress = getProgress();
    return progress['currentLevel'] ?? 1;
  }

  // Level'ı 1 artırır
  static Future<void> incrementLevel() async {
    final progress = getProgress();
    int current = progress['currentLevel'] ?? 1;
    progress['currentLevel'] = current + 1;

    // Ayrıca her level atladığında ödül vermek istersen buraya ekleyebilirsin
    progress['coins'] = (progress['coins'] ?? 0) + 20;

    await saveProgress(progress);
  }

  // Progress kaydetmek için yardımcı metod
  static Future<void> saveProgress(Map<String, dynamic> data) async {
    await saveData('game_progress', data);
  }

  // Aktif oyunu silmek için (Önceki kodunda deleteData vardı, isim uyumu için ekleyebilirsin)
  static Future<void> deleteActiveGame() async {
    await deleteData('current_game');
  }

  // ---------------- SKILL SİSTEMİ ----------------

  static Map<String, int> getSkills() {
    final box = Hive.box(_boxSkill);
    final data = box.get('skills');

    if (data != null) {
      return Map<String, int>.from(data);
    }

    // Varsayılan değerler
    return {
      ActionMode.singleExplosion.name: 0,
      ActionMode.rowColumnExplosion.name: 0,
      ActionMode.swap.name: 0,
    };
  }

  static int getSkillCount(ActionType mode) {
    final skills = getSkills();
    return skills[mode.name] ?? 0;
  }

  static Future<void> addSkill(ActionType mode) async {
    final box = Hive.box(_boxSkill);
    final skills = getSkills();

    skills[mode.name] = (skills[mode.name] ?? 0) + 1;

    await box.put('skills', skills);
  }

  static Future<void> useSkill(ActionType mode) async {
    final box = Hive.box(_boxSkill);
    final skills = getSkills();

    if ((skills[mode.name] ?? 0) > 0) {
      skills[mode.name] = skills[mode.name]! - 1;
      await box.put('skills', skills);
    }
  }
}
