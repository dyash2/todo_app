import 'package:flutter/material.dart';

class TitleProvider extends ChangeNotifier {
  String _title = "";
  String get title => _title;

  void setTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }

  void updateTitle(String newTitle) {
    _title = "${_title} - ${newTitle}";
    notifyListeners();
  }
}