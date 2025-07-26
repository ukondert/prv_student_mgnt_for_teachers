// Flutter Widget Template
// Basis-Template für ein neues Flutter Widget

import 'package:flutter/material.dart';

/// Ein wiederverwendbares Widget für [WIDGET_BESCHREIBUNG].
/// 
/// Dieses Widget folgt Flutter Best Practices:
/// - Immutable Design mit const Constructor
/// - Klare Trennung von required und optionalen Parametern
/// - Theme-Integration für konsistentes Design
/// - Accessibility Support
/// 
/// Beispiel:
/// ```dart
/// TemplateWidget(
///   title: 'Mein Titel',
///   onPressed: () => print('Gedrückt'),
///   variant: WidgetVariant.primary,
/// )
/// ```
class TemplateWidget extends StatelessWidget {
  /// Erstellt ein neues [TemplateWidget].
  const TemplateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.onPressed,
    this.variant = WidgetVariant.primary,
    this.isEnabled = true,
    this.padding,
  });

  /// Der Haupttitel des Widgets.
  final String title;

  /// Optionaler Untertitel.
  final String? subtitle;

  /// Callback-Funktion für Tap-Events.
  final VoidCallback? onPressed;

  /// Das Design-Variant des Widgets.
  final WidgetVariant variant;

  /// Ob das Widget interaktiv ist.
  final bool isEnabled;

  /// Optionales benutzerdefiniertes Padding.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Semantics(
      button: onPressed != null,
      enabled: isEnabled,
      child: Material(
        color: _getBackgroundColor(colorScheme),
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: variant == WidgetVariant.outlined
                  ? Border.all(color: colorScheme.outline)
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Titel
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: _getTextColor(colorScheme),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                // Untertitel (falls vorhanden)
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _getSubtitleColor(colorScheme),
                    ),
                  ),
                ],
                
                // Status-Indikator (falls disabled)
                if (!isEnabled) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Deaktiviert',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Bestimmt die Hintergrundfarbe basierend auf der Variante.
  Color _getBackgroundColor(ColorScheme colorScheme) {
    if (!isEnabled) {
      return colorScheme.surfaceVariant.withOpacity(0.5);
    }
    
    switch (variant) {
      case WidgetVariant.primary:
        return colorScheme.primaryContainer;
      case WidgetVariant.secondary:
        return colorScheme.secondaryContainer;
      case WidgetVariant.outlined:
        return colorScheme.surface;
      case WidgetVariant.surface:
        return colorScheme.surfaceVariant;
    }
  }

  /// Bestimmt die Textfarbe basierend auf der Variante.
  Color _getTextColor(ColorScheme colorScheme) {
    if (!isEnabled) {
      return colorScheme.onSurface.withOpacity(0.38);
    }
    
    switch (variant) {
      case WidgetVariant.primary:
        return colorScheme.onPrimaryContainer;
      case WidgetVariant.secondary:
        return colorScheme.onSecondaryContainer;
      case WidgetVariant.outlined:
        return colorScheme.onSurface;
      case WidgetVariant.surface:
        return colorScheme.onSurfaceVariant;
    }
  }

  /// Bestimmt die Untertitel-Farbe.
  Color _getSubtitleColor(ColorScheme colorScheme) {
    return _getTextColor(colorScheme).withOpacity(0.7);
  }
}

/// Definiert die verschiedenen visuellen Varianten des Widgets.
enum WidgetVariant {
  /// Primäre Variante mit hervorgehobenen Farben.
  primary,
  
  /// Sekundäre Variante mit gedämpften Farben.
  secondary,
  
  /// Outlined Variante mit Rahmen.
  outlined,
  
  /// Surface Variante mit Hintergrundfarbe.
  surface,
}

/// Extension für [WidgetVariant] mit nützlichen Eigenschaften.
extension WidgetVariantExtension on WidgetVariant {
  /// Beschreibender Name der Variante.
  String get displayName {
    switch (this) {
      case WidgetVariant.primary:
        return 'Primary';
      case WidgetVariant.secondary:
        return 'Secondary';
      case WidgetVariant.outlined:
        return 'Outlined';
      case WidgetVariant.surface:
        return 'Surface';
    }
  }

  /// Ob diese Variante einen Rahmen hat.
  bool get hasOutline => this == WidgetVariant.outlined;

  /// Ob diese Variante hervorgehoben ist.
  bool get isEmphasized => this == WidgetVariant.primary;
}
