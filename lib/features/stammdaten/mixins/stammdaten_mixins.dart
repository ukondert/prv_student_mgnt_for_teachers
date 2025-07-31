import 'package:flutter/material.dart';

/// Mixin für gemeinsame Dialog-Management-Funktionalität
mixin StammdatenDialogMixin {
  /// Zeigt eine generische Bestätigungsdialog an
  Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    required String confirmLabel,
    required String cancelLabel,
    Color? confirmButtonColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: confirmButtonColor != null
                ? FilledButton.styleFrom(backgroundColor: confirmButtonColor)
                : null,
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Zeigt eine SnackBar mit Erfolgs- oder Fehlermeldung an
  void showSnackBarMessage(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  /// Generische Fehlerbehandlung für async Operationen
  Future<void> handleAsyncOperation(
    BuildContext context, {
    required Future<void> Function() operation,
    required String successMessage,
    required String errorPrefix,
  }) async {
    try {
      await operation();
      showSnackBarMessage(context, message: successMessage);
    } catch (e) {
      showSnackBarMessage(
        context,
        message: '$errorPrefix: $e',
        isError: true,
      );
    }
  }
}

/// Mixin für gemeinsame Filter-Funktionalität
mixin StammdatenFilterMixin<T> {
  /// Generiert Schuljahr-Optionen aus einer Liste von Entitäten
  List<String> generateSchuljahrOptions<K>(
    List<K> items,
    String Function(K) schuljahrExtractor,
  ) {
    final schuljahre = items.map(schuljahrExtractor).toSet().toList();
    schuljahre.sort();
    return ['Alle Schuljahre', ...schuljahre];
  }

  /// Prüft ob ein String einen Suchterm enthält (case-insensitive)
  bool matchesSearchTerm(String text, String searchTerm) {
    return text.toLowerCase().contains(searchTerm.toLowerCase());
  }

  /// Prüft ob ein Item dem ausgewählten Schuljahr entspricht
  bool matchesSchuljahr(String itemSchuljahr, String selectedSchuljahr) {
    return selectedSchuljahr == 'Alle Schuljahre' || itemSchuljahr == selectedSchuljahr;
  }
}
