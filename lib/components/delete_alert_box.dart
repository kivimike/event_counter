import 'package:flutter/material.dart';

class DeleteAlertBox extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const DeleteAlertBox(
      {super.key, required this.onDelete, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Text(
        'Do you want to delete this record?',
        style: TextStyle(color: Colors.blueGrey.shade200),
      ),
      actions: [
        TextButton(
          onPressed: onDelete,
          child: Text(
            'Delete',
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
