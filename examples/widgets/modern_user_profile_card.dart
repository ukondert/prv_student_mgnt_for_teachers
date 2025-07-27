// Modern Flutter Widget - Demonstriert aktuelle Best Practices
// Vollständig überarbeitetes UserProfileCard Widget mit allen Features

import 'package:flutter/material.dart';

/// User Model - immutable data class mit allen notwendigen Eigenschaften
@immutable
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.role,
    this.isActive = true,
    this.lastSeen,
    this.phoneNumber,
    this.department,
  });

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? role;
  final bool isActive;
  final DateTime? lastSeen;
  final String? phoneNumber;
  final String? department;

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? role,
    bool? isActive,
    DateTime? lastSeen,
    String? phoneNumber,
    String? department,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      lastSeen: lastSeen ?? this.lastSeen,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      department: department ?? this.department,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      role: json['role'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'] as String)
          : null,
      phoneNumber: json['phoneNumber'] as String?,
      department: json['department'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'role': role,
      'isActive': isActive,
      'lastSeen': lastSeen?.toIso8601String(),
      'phoneNumber': phoneNumber,
      'department': department,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}

/// Layout Varianten für die UserProfileCard
enum UserCardLayout {
  /// Kompakt - für Listen auf mobilen Geräten
  compact,
  /// Erweitert - für Grids auf Tablets
  expanded,
  /// Detailliert - für Desktop-Ansichten
  detailed,
}

/// Modern UserProfileCard Widget mit responsiven Features
/// 
/// Demonstriert Flutter Best Practices:
/// - Const Constructor für Performance-Optimierung
/// - Responsive Design mit verschiedenen Layout-Modi
/// - Theme-Integration für konsistentes Design
/// - Accessibility Support
/// - Proper Error Handling
/// - Clean Code Principles
/// 
/// Verwendung:
/// ```dart
/// UserProfileCard(
///   user: user,
///   layout: UserCardLayout.expanded,
///   onTap: () => Navigator.push(...),
///   onEdit: () => showEditDialog(),
///   elevation: 8.0,
/// )
/// ```
class UserProfileCard extends StatelessWidget {
  const UserProfileCard({
    super.key,
    required this.user,
    this.layout = UserCardLayout.compact,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onCall,
    this.elevation = 2.0,
    this.borderRadius = 12.0,
    this.showActions = true,
    this.showStatus = true,
    this.maxWidth,
  });

  final User user;
  final UserCardLayout layout;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onCall;
  final double elevation;
  final double borderRadius;
  final bool showActions;
  final bool showStatus;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
      ),
      child: Card(
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: _getPadding(),
            child: _buildLayout(context, theme, colorScheme),
          ),
        ),
      ),
    );
  }

  EdgeInsets _getPadding() {
    return switch (layout) {
      UserCardLayout.compact => const EdgeInsets.all(12),
      UserCardLayout.expanded => const EdgeInsets.all(16),
      UserCardLayout.detailed => const EdgeInsets.all(20),
    };
  }

  Widget _buildLayout(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return switch (layout) {
      UserCardLayout.compact => _buildCompactLayout(context, theme, colorScheme),
      UserCardLayout.expanded => _buildExpandedLayout(context, theme, colorScheme),
      UserCardLayout.detailed => _buildDetailedLayout(context, theme, colorScheme),
    };
  }

  /// Kompakte Layout für mobile Listen
  Widget _buildCompactLayout(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        _buildAvatar(size: 40),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildName(theme.textTheme.titleMedium),
              const SizedBox(height: 2),
              _buildEmail(theme.textTheme.bodySmall),
              if (showStatus && user.role != null) ...[
                const SizedBox(height: 2),
                _buildRole(theme.textTheme.bodySmall, colorScheme),
              ],
            ],
          ),
        ),
        if (showStatus) _buildStatusIndicator(colorScheme),
        if (onTap != null) const Icon(Icons.chevron_right, size: 20),
      ],
    );
  }

  /// Erweiterte Layout für Tablet-Grids
  Widget _buildExpandedLayout(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildAvatar(size: 48),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildName(theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  _buildEmail(theme.textTheme.bodySmall),
                  if (user.role != null) ...[
                    const SizedBox(height: 2),
                    _buildRole(theme.textTheme.bodySmall, colorScheme),
                  ],
                ],
              ),
            ),
            if (showStatus) _buildStatusIndicator(colorScheme),
          ],
        ),
        if (showActions) ...[
          const SizedBox(height: 16),
          _buildActionButtons(compact: true),
        ],
      ],
    );
  }

  /// Detaillierte Layout für Desktop
  Widget _buildDetailedLayout(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildAvatar(size: 64),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildName(theme.textTheme.headlineSmall),
                      ),
                      if (showStatus) _buildStatusIndicator(colorScheme),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildEmail(theme.textTheme.bodyMedium),
                  if (user.role != null) ...[
                    const SizedBox(height: 4),
                    _buildRole(theme.textTheme.bodyMedium, colorScheme),
                  ],
                  if (user.department != null) ...[
                    const SizedBox(height: 4),
                    _buildDepartment(theme.textTheme.bodyMedium),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (!user.isActive && user.lastSeen != null) ...[
          const SizedBox(height: 12),
          _buildLastSeen(theme.textTheme.bodySmall),
        ],
        if (showActions) ...[
          const SizedBox(height: 20),
          _buildActionButtons(compact: false),
        ],
      ],
    );
  }

  Widget _buildAvatar({required double size}) {
    return CircleAvatar(
      radius: size / 2,
      backgroundImage: user.avatarUrl != null 
          ? NetworkImage(user.avatarUrl!)
          : null,
      child: user.avatarUrl == null
          ? Text(
              _getInitials(),
              style: TextStyle(
                fontSize: size * 0.4,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
    );
  }

  String _getInitials() {
    final names = user.name.trim().split(' ');
    if (names.length >= 2) {
      return '${names.first.substring(0, 1)}${names.last.substring(0, 1)}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names.first.substring(0, 1).toUpperCase();
    }
    return '?';
  }

  Widget _buildName(TextStyle? style) {
    return Text(
      user.name,
      style: style?.copyWith(fontWeight: FontWeight.w600),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildEmail(TextStyle? style) {
    return Text(
      user.email,
      style: style?.copyWith(color: Colors.grey[600]),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildRole(TextStyle? style, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        user.role!,
        style: style?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontSize: (style.fontSize ?? 14) * 0.85,
        ),
      ),
    );
  }

  Widget _buildDepartment(TextStyle? style) {
    return Row(
      children: [
        Icon(Icons.business, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          user.department!,
          style: style?.copyWith(color: Colors.grey[600]),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(ColorScheme colorScheme) {
    final isOnline = user.isActive;
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOnline ? Colors.green : Colors.grey,
        border: Border.all(
          color: colorScheme.surface,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildLastSeen(TextStyle? style) {
    if (user.lastSeen == null) return const SizedBox.shrink();
    
    final now = DateTime.now();
    final difference = now.difference(user.lastSeen!);
    
    String timeAgo;
    if (difference.inDays > 0) {
      timeAgo = '${difference.inDays} Tag${difference.inDays == 1 ? '' : 'e'} her';
    } else if (difference.inHours > 0) {
      timeAgo = '${difference.inHours} Stunde${difference.inHours == 1 ? '' : 'n'} her';
    } else if (difference.inMinutes > 0) {
      timeAgo = '${difference.inMinutes} Minute${difference.inMinutes == 1 ? '' : 'n'} her';
    } else {
      timeAgo = 'Gerade eben';
    }

    return Row(
      children: [
        Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          'Zuletzt gesehen: $timeAgo',
          style: style?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildActionButtons({required bool compact}) {
    final buttons = <Widget>[];

    if (onEdit != null) {
      buttons.add(
        compact
            ? IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: onEdit,
                tooltip: 'Bearbeiten',
              )
            : TextButton.icon(
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Bearbeiten'),
                onPressed: onEdit,
              ),
      );
    }

    if (onCall != null && user.phoneNumber != null) {
      buttons.add(
        compact
            ? IconButton(
                icon: const Icon(Icons.phone, size: 20),
                onPressed: onCall,
                tooltip: 'Anrufen',
              )
            : TextButton.icon(
                icon: const Icon(Icons.phone, size: 18),
                label: const Text('Anrufen'),
                onPressed: onCall,
              ),
      );
    }

    if (onDelete != null) {
      buttons.add(
        compact
            ? IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: onDelete,
                tooltip: 'Löschen',
              )
            : TextButton.icon(
                icon: const Icon(Icons.delete, size: 18),
                label: const Text('Löschen'),
                onPressed: onDelete,
              ),
      );
    }

    if (buttons.isEmpty) return const SizedBox.shrink();

    return compact
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buttons,
          )
        : Wrap(
            spacing: 8,
            children: buttons,
          );
  }
}
