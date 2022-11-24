import 'package:flutter/material.dart';

class MainMenuButton extends StatelessWidget {
  final Function()? onPressed;
  MainMenuButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: onPressed,
      backgroundColor: Colors.orange,
      child: Icon(Icons.add_outlined,),
      foregroundColor: Colors.blueGrey.shade900,

    );
  }
}
