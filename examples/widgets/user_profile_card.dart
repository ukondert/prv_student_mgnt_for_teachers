// Flutter Widget Pattern Beispiel
// Stateless Widget mit Material Design

import 'package:flutter/material.dart';

/// Ein wiederverwendbares Widget zur Anzeige von Benutzer-Profil-Informationen.
/// 
/// Dieses Widget demonstriert Flutter Best Practices:
/// - Const Constructor für Performance
/// - Required und optionale Parameter
/// - Theme-Integration
/// - Responsive Design
/// - Accessibility Support
/// 
/// Beispiel:
/// ```dart
/// UserProfileCard(
///   user: user,
///   onTap: () => Navigator.push(...),
///   elevation: 8.0,
/// )
/// ```
class UserProfileCard extends StatelessWidget {
  const UserProfileCard({
    super.key,
    required this.user,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.elevation = 4.0,
    this.borderRadius = 12.0,
    this.showActions = true,
  });

  final User user;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final double elevation;
  final double borderRadius;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Row with Avatar and Actions
              Row(
                children: [
                  // Avatar
                  Hero(
                    tag: 'user-avatar-${user.id}',
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: colorScheme.primaryContainer,
                      backgroundImage: user.avatarUrl != null
                          ? NetworkImage(user.avatarUrl!)
                          : null,
                      child: user.avatarUrl == null
                          ? Text(
                              user.initials,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                              ),
                            )
                          : null,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (user.role != null) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              user.role!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Actions Menu
                  if (showActions)
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            onEdit?.call();
                            break;
                          case 'delete':
                            onDelete?.call();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Bearbeiten'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Löschen', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              
              // Status and Last Seen
              if (user.lastSeen != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: user.isOnline ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      user.isOnline 
                          ? 'Online' 
                          : 'Zuletzt gesehen: ${_formatLastSeen(user.lastSeen!)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} Tag${difference.inDays == 1 ? '' : 'e'}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} Stunde${difference.inHours == 1 ? '' : 'n'}';
    } else {
      return '${difference.inMinutes} Minute${difference.inMinutes == 1 ? '' : 'n'}';
    }
  }
}

/// User Data Model für das Widget
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.role,
    this.lastSeen,
    this.isOnline = false,
  });

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? role;
  final DateTime? lastSeen;
  final bool isOnline;

  /// Generiert Initialen aus dem Namen
  String get initials {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names.first.substring(0, 1)}${names.last.substring(0, 1)}';
    }
    return name.substring(0, 1);
  }
}
