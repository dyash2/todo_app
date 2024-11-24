import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PagesProvider extends ChangeNotifier {
  final List<Map<String, String>> _images = []; // [{path: '', title: ''}]
  List<Map<String, String>> get images => _images;

  // Load data from SharedPreferences
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

  // Add new image with an empty title
  Future<void> addImage(String path, String title) async {
    _images.add({'path': path, 'title': title});  // Empty title by default
    await _saveToPreferences();
    notifyListeners();
  }

  // Update the title of an image
  Future<void> updateImageTitle(int index, String newTitle) async {
    _images[index]['title'] = newTitle;
    await _saveToPreferences();
    notifyListeners();
  }

  // Save all data to SharedPreferences
  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('images', jsonEncode(_images));
  }

  // Remove an image
  Future<void> removeImage(int index) async {
    _images.removeAt(index);
    await _saveToPreferences();
    notifyListeners();
  }
}
