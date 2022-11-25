import 'package:flutter/material.dart';

class RecordTile extends StatelessWidget {
  final String name;
  final String date;
  final Function()? onDelete;

  const RecordTile({
    super.key,
    required this.name,
    required this.date,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.blueGrey,
        elevation: 10,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16, bottom: 4),
                  child: Text(
                    'Name: ${name.replaceAll('\n', ' ').padRight(25, ' ').substring(0, 25)}',
                    style: TextStyle(color: Colors.orange.shade50, fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4, bottom: 16.0),
                  child: Text(
                    'Date: ${date}',
                    style: TextStyle(color: Colors.orange.shade50, fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                )
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(onPressed: onDelete, icon: Icon(Icons.delete, color: Colors.orange.shade50,)),
            ),
          ],
        ),
      ),
    );
  }
}
