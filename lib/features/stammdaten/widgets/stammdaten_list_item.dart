import 'package:flutter/material.dart';

/// Generisches ListItem-Widget für Stammdaten-Entitäten
class StammdatenListItem<T> extends StatelessWidget {
  const StammdatenListItem({
    super.key,
    required this.item,
    required this.title,
    required this.subtitle,
    this.leading,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.editLabel = 'Bearbeiten',
    this.deleteLabel = 'Löschen',
    this.showDeleteAction = true,
  });

  final T item;
  final String title;
  final Widget subtitle;
  final Widget? leading;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String editLabel;
  final String deleteLabel;
  final bool showDeleteAction;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    return Card(
      margin: isMobile 
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)  // Mobile: Weniger horizontaler Abstand
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // Desktop: Mehr horizontaler Abstand
      child: SizedBox(
        width: isMobile ? double.infinity : null, // Mobile: Volle Breite verwenden
        child: ListTile(
          leading: leading,
          title: Text(title),
          subtitle: subtitle,
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  onEdit();
                  break;
                case 'delete':
                  onDelete();
                  break;
              }
            },
            itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  const Icon(Icons.edit),
                  const SizedBox(width: 8),
                  Text(editLabel),
                ],
              ),
            ),
            if (showDeleteAction)
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(deleteLabel),
                  ],
                ),
              ),
          ],
        ),
        onTap: onTap,
        ),
      ),
    );
  }
}
