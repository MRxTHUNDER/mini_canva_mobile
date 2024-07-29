import 'package:flutter/material.dart';

class TextItem {
  String text;
  double fontSize;
  Color fontColor;
  Offset position;

  TextItem({
    required this.text,
    required this.fontSize,
    required this.fontColor,
    required this.position,
  });

  // Adding a copyWith method for copying TextItem with modifications
  TextItem copyWith({
    String? text,
    double? fontSize,
    Color? fontColor,
    Offset? position,
  }) {
    return TextItem(
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      fontColor: fontColor ?? this.fontColor,
      position: position ?? this.position,
    );
  }
}

class EditorProvider extends ChangeNotifier {
  double _fontSize = 16.0;
  Color _fontColor = Colors.black;
  List<TextItem> _texts = [];
  List<List<TextItem>> _history = [];

  double get fontSize => _fontSize;
  Color get fontColor => _fontColor;
  List<TextItem> get texts => _texts;

  void updateFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners();
  }

  void updateFontColor(Color newColor) {
    _fontColor = newColor;
    notifyListeners();
  }

  void addText(String newText, Offset position) {
    if (newText.isNotEmpty) {
      _saveToHistory();
      _texts.add(TextItem(
        text: newText,
        fontSize: _fontSize,
        fontColor: _fontColor,
        position: position,
      ));
      notifyListeners();
    }
  }

  void updateTextPosition(int index, Offset newPosition) {
    _saveToHistory();
    _texts[index] = _texts[index].copyWith(position: newPosition);
    notifyListeners();
  }

  void deleteText(int index) {
    _saveToHistory();
    _texts.removeAt(index);
    notifyListeners();
  }

  void _saveToHistory() {
    _history.add(_texts.map((text) => text.copyWith()).toList());
  }

  void undo() {
    if (_history.isNotEmpty) {
      _texts = _history.removeLast();
      notifyListeners();
    }
  }
}
