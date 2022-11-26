import 'package:flutter/material.dart';

class SaveAlertBox extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final controller;

  const SaveAlertBox(
      {super.key,
      required this.onSave,
      required this.onCancel,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Record name',
          hintStyle: TextStyle(color: Colors.blueGrey.shade300)
        ),
        style: TextStyle(color: Colors.blueGrey.shade200),
        minLines: 1,
        maxLines: 2,
      ),
      actions: [
        TextButton(
          onPressed: onSave,
          child: Text(
            'Save',
            style: TextStyle(color: Colors.blueGrey),
          ),
        ),
        TextButton(
            onPressed: onCancel,
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.blueGrey),
            )),
      ],
    );
  }
}
