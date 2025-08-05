// lib/widgets/confirmation_dialog.dart
import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog(
    BuildContext context,
    String message, {
      String? title,
      String? confirmText,
      String? cancelText,
    }) async {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      title: Text(
        title ?? 'Confirm',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      content: Text(
        message,
        style: TextStyle(
          color: isDark ? Colors.grey[300] : Colors.black87,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(cancelText ?? 'Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? Colors.tealAccent : Theme.of(context).colorScheme.primary,
            foregroundColor: isDark ? Colors.black : Colors.white,
          ),
          child: Text(confirmText ?? 'OK'),
        ),
      ],
    ),
  ) ??
      false;
}
