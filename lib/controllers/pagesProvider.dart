import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PagesProvider extends ChangeNotifier {
  final List<Map<String, String>> _images = [];
  List<Map<String, String>> get images => _images;

  Future<void> loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString('images');
    if (storedData != null) {
      final List<dynamic> data = jsonDecode(storedData);
      _images.clear();
      for (var item in data) {
        _images.add(Map<String, String>.from(item));
      }
    }
    notifyListeners();
  }

  Future<void> addImage(String path, String title) async {
    _images.add({'path': path, 'title': title}); // Empty title by default
    await _saveToPreferences();
    notifyListeners();
  }

  Future<void> updateImageTitle(int index, String newTitle) async {
    _images[index]['title'] = newTitle;
    await _saveToPreferences();
    notifyListeners();
  }

  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('images', jsonEncode(_images));
  }

  Future<void> removeImage(int index) async {
    _images.removeAt(index);
    await _saveToPreferences();
    notifyListeners();
  }

  Future<void> moveImage(int oldIndex, int newIndex) async {
    final image = _images.removeAt(oldIndex);
    _images.insert(newIndex, image);
    await _saveToPreferences();
    notifyListeners();
  }
}
