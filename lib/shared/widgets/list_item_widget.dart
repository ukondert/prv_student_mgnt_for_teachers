import 'package:flutter/material.dart';

/// Wiederverwendbares Widget für Listenelemente mit konsistentem Design
/// 
/// Provides a consistent design pattern for list items with:
/// - Leading icon/avatar
/// - Title and subtitle
/// - Optional badge/info
/// - Edit and delete actions on the right
class ListItemWidget extends StatelessWidget {
  const ListItemWidget({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.badge,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.margin,
  });

  /// Widget displayed on the left (typically an icon or avatar)
  final Widget leading;
  
  /// Main title text
  final String title;
  
  /// Optional subtitle widget (can be text, chips, etc.)
  final Widget? subtitle;
  
  /// Optional badge widget displayed next to the title
  final Widget? badge;
  
  /// Callback when the item is tapped
  final VoidCallback? onTap;
  
  /// Callback when edit button is pressed
  final VoidCallback? onEdit;
  
  /// Callback when delete button is pressed
  final VoidCallback? onDelete;
  
  /// Custom margin for the card
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Leading icon/avatar
              leading,
              
              const SizedBox(width: 12),
              
              // Content area (title, subtitle, badge)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row with optional badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          badge!,
                        ],
                      ],
                    ),
                    
                    // Optional subtitle
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      subtitle!,
                    ],
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Action buttons (edit and delete)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: onEdit,
                      tooltip: 'Bearbeiten',
                      visualDensity: VisualDensity.compact,
                    ),
                  
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: onDelete,
                      tooltip: 'Löschen',
                      visualDensity: VisualDensity.compact,
                      color: Theme.of(context).colorScheme.error,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Vorgefertigte Badge-Widgets für häufige Anwendungsfälle

/// Standard Badge für Kürzel
class KuerzelBadge extends StatelessWidget {
  const KuerzelBadge({
    super.key,
    required this.kuerzel,
  });

  final String kuerzel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        kuerzel,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

/// Chips für Klassen-Zuordnungen
class KlassenChipsWidget extends StatelessWidget {
  const KlassenChipsWidget({
    super.key,
    required this.klassenNames,
    this.maxVisible = 3,
  });

  final List<String> klassenNames;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    if (klassenNames.isEmpty) {
      return const Text(
        'Keine Klassen zugeordnet',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 4,
          children: klassenNames.take(maxVisible).map((klassenName) {
            return Chip(
              label: Text(klassenName),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          }).toList(),
        ),
        if (klassenNames.length > maxVisible)
          Text(
            '+ ${klassenNames.length - maxVisible} weitere',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
      ],
    );
  }
}
