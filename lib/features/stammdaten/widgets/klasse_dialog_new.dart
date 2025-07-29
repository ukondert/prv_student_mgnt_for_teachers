import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../models/klasse.dart';
import '../providers/klassen_provider.dart';

class KlasseDialog extends StatefulWidget {
  final Klasse? klasse;
  final bool isMobile;

  const KlasseDialog({
    super.key,
    this.klasse,
    this.isMobile = false,
  });

  // Named constructor for mobile (BottomSheet)
  const KlasseDialog.mobile({
    super.key,
    this.klasse,
  }) : isMobile = true;

  // Named constructor for desktop (AlertDialog)
  const KlasseDialog.desktop({
    super.key,
    this.klasse,
  }) : isMobile = false;

  @override
  State<KlasseDialog> createState() => _KlasseDialogState();
}

class _KlasseDialogState extends State<KlasseDialog> {
  late final FormGroup form;
  bool get isEditing => widget.klasse != null;

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'name': FormControl<String>(
        value: widget.klasse?.name ?? '',
        validators: [
          Validators.required,
          Validators.minLength(2),
          Validators.maxLength(20),
          Validators.pattern(r'^[A-Z0-9][A-Z0-9]*$'),
        ],
      ),
      'schuljahr': FormControl<String>(
        value: widget.klasse?.schuljahr ?? _getCurrentSchuljahr(),
        validators: [
          Validators.required,
          Validators.pattern(r'^\d{4}/\d{2}$'),
        ],
      ),
    });
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  String _getCurrentSchuljahr() {
    final now = DateTime.now();
    final startYear = now.month >= 9 ? now.year : now.year - 1;
    final endYear = startYear + 1;
    return '$startYear/${endYear.toString().substring(2)}';
  }

  List<String> _getSchuljahrOptions() {
    final current = DateTime.now().year;
    return List.generate(5, (index) {
      final startYear = current - 2 + index;
      final endYear = startYear + 1;
      return '$startYear/${endYear.toString().substring(2)}';
    });
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
          title: Text(isEditing ? 'Klasse bearbeiten' : 'Neue Klasse'),
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
                _buildFormContent(context),
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
                  flex: 2,
                  child: ReactiveFormConsumer(
                    builder: (context, form, child) {
                      return ElevatedButton.icon(
                        onPressed: form.valid ? _saveKlasse : null,
                        icon: Icon(isEditing ? Icons.save : Icons.add),
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
                      isEditing ? Icons.edit : Icons.add,
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
                          isEditing ? 'Klasse bearbeiten' : 'Neue Klasse',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isEditing ? 'Klasseninformationen ändern' : 'Eine neue Klasse erstellen',
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

              _buildFormContent(context),

              const SizedBox(height: 24),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Abbrechen'),
                  ),
                  const SizedBox(width: 12),
                  ReactiveFormConsumer(
                    builder: (context, form, child) {
                      return ElevatedButton.icon(
                        onPressed: form.valid ? _saveKlasse : null,
                        icon: Icon(isEditing ? Icons.save : Icons.add),
                        label: Text(isEditing ? 'Speichern' : 'Erstellen'),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Form Fields
        // Klassename
        ReactiveTextField<String>(
          formControlName: 'name',
          decoration: InputDecoration(
            labelText: 'Klassenname *',
            hintText: 'z.B. 4AHITS, 3BMIT, 5AHET',
            helperText: 'Format: Jahrgang + Klasse + Abteilung (z.B. 4AHITS)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: const Icon(Icons.class_),
          ),
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.characters,
          validationMessages: {
            ValidationMessage.required: (_) => 'Klassenname ist erforderlich',
            ValidationMessage.minLength: (_) => 'Mindestens 2 Zeichen',
            ValidationMessage.maxLength: (_) => 'Maximal 20 Zeichen',
            ValidationMessage.pattern: (_) => 'Nur Großbuchstaben und Zahlen erlaubt',
          },
        ),

        const SizedBox(height: 16),

        // Schuljahr
        ReactiveDropdownField<String>(
          formControlName: 'schuljahr',
          decoration: InputDecoration(
            labelText: 'Schuljahr *',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: const Icon(Icons.calendar_today),
          ),
          items: _getSchuljahrOptions().map((jahr) {
            return DropdownMenuItem(
              value: jahr,
              child: Text(jahr),
            );
          }).toList(),
          validationMessages: {
            ValidationMessage.required: (_) => 'Schuljahr ist erforderlich',
            ValidationMessage.pattern: (_) => 'Ungültiges Schuljahr-Format',
          },
        ),

        const SizedBox(height: 24),

        // Info Card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Nach dem Erstellen können Sie Schüler zu dieser Klasse hinzufügen.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _saveKlasse() async {
    if (!form.valid) return;

    final formValue = form.value;
    final name = formValue['name'] as String;
    final schuljahr = formValue['schuljahr'] as String;

    try {
      final provider = context.read<KlassenProvider>();
      
      if (isEditing) {
        final updatedKlasse = widget.klasse!.copyWith(
          name: name,
          schuljahr: schuljahr,
        );
        await provider.updateKlasse(updatedKlasse);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Klasse "$name" wurde aktualisiert'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }
      } else {
        final neueKlasse = Klasse.neu(
          name: name,
          schuljahr: schuljahr,
        );
        await provider.createKlasse(neueKlasse);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Klasse "$name" wurde erstellt'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              action: SnackBarAction(
                label: 'Ansehen',
                textColor: Theme.of(context).colorScheme.onPrimary,
                onPressed: () {
                  // TODO: Navigate to class detail view
                },
              ),
            ),
          );
        }
      }

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
    }
  }
}
