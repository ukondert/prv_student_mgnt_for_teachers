import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Basis-Widget für responsive Stammdaten-Dialoge
/// 
/// Diese abstrakte Klasse stellt die gemeinsame Struktur für alle
/// Stammdaten-Dialoge (Klassen, Fächer, Schüler) bereit und eliminiert
/// Code-Duplikation.
abstract class BaseDialog<T> extends StatefulWidget {
  final T? item;
  final bool isMobile;

  const BaseDialog({
    super.key,
    this.item,
    this.isMobile = false,
  });

  /// Named constructor für mobile Layout (BottomSheet)
  const BaseDialog.mobile({
    super.key,
    this.item,
  }) : isMobile = true;

  /// Named constructor für desktop Layout (Dialog)
  const BaseDialog.desktop({
    super.key,
    this.item,
  }) : isMobile = false;
}

/// Basis-State für responsive Stammdaten-Dialoge
abstract class BaseDialogState<W extends BaseDialog<T>, T> extends State<W> {
  late final FormGroup form;
  bool isLoading = false;

  /// Getter für Editing-Modus
  bool get isEditing => widget.item != null;

  /// Titel für den Dialog
  String get dialogTitle;

  /// Untertitel für den Dialog
  String get dialogSubtitle;

  /// Icon für den Dialog
  IconData get dialogIcon;

  /// Erstellt die Form-Gruppe für das spezifische Model
  FormGroup createForm();

  /// Baut den Formular-Inhalt
  Widget buildFormContent(BuildContext context);

  /// Speichert das Item
  Future<void> saveItem();

  @override
  void initState() {
    super.initState();
    form = createForm();
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isMobile) {
      return _buildMobileLayout(context);
    } else {
      return _buildDesktopLayout(context);
    }
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.9,
      child: Scaffold(
        appBar: AppBar(
          title: Text(dialogTitle),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
        ),
        body: ReactiveForm(
          formGroup: form,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildFormContent(context),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Abbrechen'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StreamBuilder<ControlStatus>(
                    stream: form.statusChanged,
                    initialData: form.status,
                    builder: (context, snapshot) {
                      final isValid = snapshot.data == ControlStatus.valid;
                      return ElevatedButton.icon(
                        onPressed: (isValid && !isLoading) ? _handleSave : null,
                        icon: isLoading 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(isEditing ? Icons.save : Icons.add),
                        label: Text(isEditing ? 'Speichern' : 'Erstellen'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      dialogIcon,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dialogTitle,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          dialogSubtitle,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Flexible(
                child: SingleChildScrollView(
                  child: buildFormContent(context),
                ),
              ),

              const SizedBox(height: 24),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Abbrechen'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StreamBuilder<ControlStatus>(
                      stream: form.statusChanged,
                      initialData: form.status,
                      builder: (context, snapshot) {
                        final isValid = snapshot.data == ControlStatus.valid;
                        return ElevatedButton.icon(
                          onPressed: (isValid && !isLoading) ? _handleSave : null,
                          icon: isLoading 
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(isEditing ? Icons.save : Icons.add),
                          label: Text(isEditing ? 'Speichern' : 'Erstellen'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!form.valid || isLoading) return;

    setState(() => isLoading = true);

    try {
      await saveItem();
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Speichern: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
}
