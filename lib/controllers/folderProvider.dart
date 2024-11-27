import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:developer' as l;
import 'package:shared_preferences/shared_preferences.dart';

class FolderProvider with ChangeNotifier {
  List<Map<String, dynamic>> _folders = [];
  List<Map<String, dynamic>> get folders => _folders;

  FolderProvider() {
    loadFolders();
  }

  Future<void> loadFolders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('folders');
    if (savedData != null) {
      _folders = List<Map<String, dynamic>>.from(json.decode(savedData));
      l.log("Loaded Folders: $_folders");
    } else {
      l.log("No folders found");
    }
    notifyListeners();
  }

  Future<void> saveFolders() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('folders', json.encode(_folders));
    l.log("Saved Folders: ${prefs.getString('folders')}");
  }

  void addFolder(String title, String description, String date) {
    _folders.add({
      "title": title,
      "description": description,
      "date": date,
    });
    l.log("Adding folder: ${json.encode(_folders)}");
    saveFolders();
    notifyListeners();
  }

  void removeFolder(int index) {
    _folders.removeAt(index);
    l.log("Removing folder: ${json.encode(_folders)}");
    saveFolders();
    notifyListeners();
  }

  void updateFolderTitle(int index, String title) {
    if (index >= 0 && index < _folders.length) {
      _folders[index]['title'] = title;
      l.log("Updated folder title: ${json.encode(_folders[index])}");
      saveFolders();
      notifyListeners();
    } else {
      l.log("Invalid index for updating folder title.");
    }
  }

  void updateFolder(int index, String title, String description, String date) {
    if (index >= 0 && index < _folders.length) {
      _folders[index] = {
        "title": title,
        "description": description,
        "date": date,
      };
      l.log("Updated folder: ${json.encode(_folders[index])}");
      saveFolders();
      notifyListeners();
    } else {
      l.log("Invalid index for updating folder.");
    }
  }
}
