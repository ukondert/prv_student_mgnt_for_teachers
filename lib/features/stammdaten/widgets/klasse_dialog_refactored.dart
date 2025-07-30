import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../models/klasse.dart';
import '../providers/klassen_provider.dart';
import '../../../shared/widgets/base_dialog.dart';

class KlasseDialogRefactored extends BaseDialog<Klasse> {
  const KlasseDialogRefactored({
    super.key,
    super.item,
    super.isMobile = false,
  });

  const KlasseDialogRefactored.mobile({
    super.key,
    super.item,
  }) : super.mobile();

  const KlasseDialogRefactored.desktop({
    super.key,
    super.item,
  }) : super.desktop();

  @override
  State<KlasseDialogRefactored> createState() => _KlasseDialogRefactoredState();
}

class _KlasseDialogRefactoredState extends BaseDialogState<KlasseDialogRefactored, Klasse> {
  @override
  String get dialogTitle => isEditing ? 'Klasse bearbeiten' : 'Neue Klasse';

  @override
  String get dialogSubtitle => isEditing ? 'Klasseninformationen ändern' : 'Eine neue Klasse erstellen';

  @override
  IconData get dialogIcon => isEditing ? Icons.edit : Icons.add;

  @override
  FormGroup createForm() {
    return FormGroup({
      'name': FormControl<String>(
        value: widget.item?.name ?? '',
        validators: [
          Validators.required,
          Validators.minLength(2),
          Validators.maxLength(20),
          Validators.pattern(r'^[A-Z0-9][A-Z0-9]*$'),
        ],
      ),
      'schuljahr': FormControl<String>(
        value: widget.item?.schuljahr ?? _getCurrentSchuljahr(),
        validators: [
          Validators.required,
          Validators.pattern(r'^\d{4}/\d{2}$'),
        ],
      ),
    });
  }

  @override
  Widget buildFormContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
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

  @override
  Future<void> saveItem() async {
    final formValue = form.value;
    final name = formValue['name'] as String;
    final schuljahr = formValue['schuljahr'] as String;

    final provider = context.read<KlassenProvider>();

    if (isEditing) {
      final updatedKlasse = widget.item!.copyWith(
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
}
