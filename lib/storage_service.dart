import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class StorageService {
  static const String _storageKey = 'saved_cvs';

  static Future<void> saveCV(CVData cv) async {
    final prefs = await SharedPreferences.getInstance();
    final List<CVData> allCvs = await getAllCVs();

    final index = allCvs.indexWhere((element) => element.id == cv.id);
    if (index != -1) {
      allCvs[index] = cv;
    } else {
      allCvs.add(cv);
    }

    final String encoded = jsonEncode(allCvs.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  static Future<List<CVData>> getAllCVs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_storageKey);
    if (encoded == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(encoded);
      return decoded.map((e) => CVData.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> deleteCV(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<CVData> allCvs = await getAllCVs();
    allCvs.removeWhere((element) => element.id == id);

    final String encoded = jsonEncode(allCvs.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  static Future<CVData?> getCV(String id) async {
    final List<CVData> allCvs = await getAllCVs();
    try {
      return allCvs.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }
}
