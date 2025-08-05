// lib/widgets/list_tile_with_actions.dart
import 'package:flutter/material.dart';

class ListTileWithActions extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ListTileWithActions({
    Key? key,
    required this.title,
    this.subtitle,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.tealAccent : Theme.of(context).colorScheme.primary;
    final deleteColor = isDark ? Colors.redAccent[200] : Colors.red;

    return Card(
      elevation: 2,
      color: isDark ? Colors.grey[850] : Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
          subtitle!,
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.black54,
          ),
        )
            : null,
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: iconColor,
              tooltip: 'Edit',
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: deleteColor,
              tooltip: 'Delete',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
