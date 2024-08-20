import 'package:flutter/material.dart';

void showSuccessDialog(BuildContext context, VoidCallback onOkPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Puzzle Solved! 🎉",
          style:
              TextStyle(color: Colors.green[600], fontWeight: FontWeight.w800),
        ),
        content: Text("Congratulations! You've solved the 8 Queens Puzzle."),
        actions: [
          InkWell(
            onTap: onOkPressed,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "OK",
                style: TextStyle(
                    color: Colors.blue[600], fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      );
    },
  );
}
