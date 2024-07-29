import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'editor_provider.dart';

class Workspace extends StatefulWidget {
  @override
  _WorkspaceState createState() => _WorkspaceState();
}

class _WorkspaceState extends State<Workspace> {
  int? _selectedTextIndex;

  void _onKey(RawKeyEvent event) {
    if (_selectedTextIndex != null &&
        event.logicalKey == LogicalKeyboardKey.delete) {
      Provider.of<EditorProvider>(context, listen: false)
          .deleteText(_selectedTextIndex!);
      setState(() {
        _selectedTextIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: _onKey,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Stack(
            children: [
              Consumer<EditorProvider>(
                builder: (context, editor, child) {
                  return Stack(
                    children: editor.texts.asMap().entries.map((entry) {
                      int index = entry.key;
                      TextItem textItem = entry.value;
                      return Positioned(
                        left: textItem.position.dx,
                        top: textItem.position.dy,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTextIndex = index;
                            });
                          },
                          onPanUpdate: (details) {
                            setState(() {
                              editor.updateTextPosition(index, details.globalPosition);
                            });
                          },
                          child: Container(
                            color: _selectedTextIndex == index
                                ? Colors.yellow.withOpacity(0.3)
                                : Colors.transparent,
                            child: Text(
                              textItem.text,
                              style: TextStyle(
                                fontSize: textItem.fontSize,
                                color: textItem.fontColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}