import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'editor_provider.dart';

class EditorSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    TextEditingController fontSizeController = TextEditingController(
      text: context.watch<EditorProvider>().fontSize.toString(),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Font Size:'),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: context.watch<EditorProvider>().fontSize,
                  min: 8,
                  max: 72,
                  onChanged: (value) {
                    context.read<EditorProvider>().updateFontSize(value);
                    fontSizeController.text = value.toStringAsFixed(0);
                  },
                ),
              ),
              SizedBox(
                width: 50,
                child: TextField(
                  controller: fontSizeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  ),
                  onSubmitted: (value) {
                    double? newSize = double.tryParse(value);
                    if (newSize != null && newSize >= 8 && newSize <= 72) {
                      context.read<EditorProvider>().updateFontSize(newSize);
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Text('Font Color:'),
          SizedBox(height: 10,),
          Row(
            children: [
              ColorButton(Colors.black),
              ColorButton(Colors.red),
              ColorButton(Colors.green),
              ColorButton(Colors.blue),
            ],
          ),
          SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            controller: textController,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(255, 220, 232, 251),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50),
              ),
              hintText: 'Add Text'
            ),
            onSubmitted: (value) {
              final center = Offset(
                MediaQuery.of(context).size.width / 2,
                MediaQuery.of(context).size.height / 2,
              );
              context.read<EditorProvider>().addText(value, center);
              textController.clear();
            },
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              context.read<EditorProvider>().undo();
            },
            child: Text('Undo'),
          ),
        ],
      ),
    );
  }
}

class ColorButton extends StatelessWidget {
  final Color color;

  ColorButton(this.color);

  @override
  Widget build(BuildContext context) {
    bool isSelected = context.watch<EditorProvider>().fontColor == color;

    return GestureDetector(
      onTap: () {
        context.read<EditorProvider>().updateFontColor(color);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ]
              : [],
        ),
      ),
    );
  }
}
