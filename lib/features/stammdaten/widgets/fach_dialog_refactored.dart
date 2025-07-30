import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../models/fach.dart';
import '../providers/faecher_provider.dart';
import '../providers/klassen_provider.dart';
import '../../../shared/widgets/base_dialog.dart';

class FachDialogRefactored extends BaseDialog<Fach> {
  const FachDialogRefactored({
    super.key,
    super.item,
    super.isMobile = false,
  });

  const FachDialogRefactored.mobile({
    super.key,
    super.item,
  }) : super.mobile();

  const FachDialogRefactored.desktop({
    super.key,
    super.item,
  }) : super.desktop();

  @override
  State<FachDialogRefactored> createState() => _FachDialogRefactoredState();
}

class _FachDialogRefactoredState extends BaseDialogState<FachDialogRefactored, Fach> {
  @override
  String get dialogTitle => isEditing ? 'Fach bearbeiten' : 'Neues Fach';

  @override
  String get dialogSubtitle => isEditing ? 'Fachinformationen ändern' : 'Ein neues Fach erstellen';

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
        ],
      ),
      'kuerzel': FormControl<String>(
        value: widget.item?.kuerzel ?? '',
        validators: [
          Validators.required,
          Validators.minLength(1),
          Validators.maxLength(5),
        ],
      ),
      'klassenIds': FormControl<List<String>>(
        value: widget.item?.klassenIds ?? [],
      ),
    });
  }

  @override
  Widget buildFormContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fach-Name
        ReactiveTextField<String>(
          formControlName: 'name',
          decoration: const InputDecoration(
            labelText: 'Fach-Name *',
            helperText: 'z.B. Softwareentwicklung, Mathematik',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
          validationMessages: {
            ValidationMessage.required: (error) => 'Fach-Name ist erforderlich',
            ValidationMessage.minLength: (error) => 'Mindestens 2 Zeichen erforderlich',
          },
        ),
        
        const SizedBox(height: 16),
        
        // Kürzel Field
        ReactiveTextField<String>(
          formControlName: 'kuerzel',
          decoration: const InputDecoration(
            labelText: 'Kürzel *',
            helperText: 'z.B. SWE, M, D (max. 5 Zeichen)',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.characters,
          validationMessages: {
            ValidationMessage.required: (error) => 'Kürzel ist erforderlich',
            ValidationMessage.minLength: (error) => 'Mindestens 1 Zeichen erforderlich',
            ValidationMessage.maxLength: (error) => 'Maximal 5 Zeichen erlaubt',
          },
        ),
        
        const SizedBox(height: 16),
        
        // Klassen Assignment Section
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Zugeordnete Klassen',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Klassen Multi-Select
        Consumer<KlassenProvider>(
          builder: (context, klassenProvider, child) {
            if (klassenProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final allKlassen = klassenProvider.klassen;
            if (allKlassen.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Keine Klassen verfügbar. Erstellen Sie zuerst eine Klasse.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return ReactiveFormField<List<String>, dynamic>(
              formControlName: 'klassenIds',
              builder: (field) {
                final selectedIds = field.value ?? <String>[];
                
                return Column(
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          itemCount: allKlassen.length,
                          itemBuilder: (context, index) {
                            final klasse = allKlassen[index];
                            final isSelected = selectedIds.contains(klasse.id);
                            
                            return CheckboxListTile(
                              title: Text(klasse.name),
                              subtitle: Text('Schuljahr: ${klasse.schuljahr}'),
                              value: isSelected,
                              onChanged: (bool? checked) {
                                final newList = List<String>.from(selectedIds);
                                
                                if (checked == true) {
                                  newList.add(klasse.id);
                                } else {
                                  newList.remove(klasse.id);
                                }
                                
                                field.didChange(newList);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
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
                  'Sie können später weitere Klassen zu diesem Fach hinzufügen.',
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
    final kuerzel = formValue['kuerzel'] as String;
    final klassenIds = formValue['klassenIds'] as List<String>;

    final provider = context.read<FaecherProvider>();

    if (isEditing) {
      await provider.updateFach(
        widget.item!.id,
        name,
        kuerzel,
        klassenIds,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fach "$name" wurde aktualisiert'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } else {
      await provider.createFach(
        name,
        kuerzel,
        klassenIds,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fach "$name" wurde erstellt'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            action: SnackBarAction(
              label: 'Ansehen',
              textColor: Theme.of(context).colorScheme.onPrimary,
              onPressed: () {
                // TODO: Navigate to fach detail view
              },
            ),
          ),
        );
      }
    }
  }
}
