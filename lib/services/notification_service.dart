import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class NotificationService {
  void showNotification(
    BuildContext context,
    String message,
    String type) {

    Color background = Colors.white;

    if (type == "success") {
      background = Colors.green.shade400;
    }

    if (type == "neutral") {
      background = Colors.lightBlue;
    }

    if (type == "error") {
      background = Colors.redAccent;
    }

    showTopSnackBar(
      context,
      Material(
        borderRadius: BorderRadius.circular(25.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: background,
          ),
          child: Center(child: Text(message,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.justify,
            )
          ),
        ),
      ),
    );

  }
}