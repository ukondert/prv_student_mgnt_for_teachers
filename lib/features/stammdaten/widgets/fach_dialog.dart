import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../models/fach.dart';
import '../models/klasse.dart';
import '../providers/faecher_provider.dart';
import '../providers/klassen_provider.dart';

class FachDialog extends StatefulWidget {
  final Fach? fach;

  const FachDialog({
    super.key,
    this.fach,
  });

  // Named constructors for platform-adaptive behavior
  const FachDialog.mobile({
    super.key,
    this.fach,
  });

  const FachDialog.desktop({
    super.key,
    this.fach,
  });

  @override
  State<FachDialog> createState() => _FachDialogState();
}

class _FachDialogState extends State<FachDialog> {
  late FormGroup form;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize form with current fach data or defaults
    form = FormGroup({
      'name': FormControl<String>(
        value: widget.fach?.name ?? '',
        validators: [
          Validators.required,
          Validators.minLength(2),
        ],
      ),
      'kuerzel': FormControl<String>(
        value: widget.fach?.kuerzel ?? '',
        validators: [
          Validators.required,
          Validators.minLength(1),
          Validators.maxLength(5),
        ],
      ),
      'klassenIds': FormControl<List<String>>(
        value: widget.fach?.klassenIds ?? [],
      ),
    });
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  Future<void> _saveFach() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final faecherProvider = Provider.of<FaecherProvider>(context, listen: false);
      
      final name = form.control('name').value as String;
      final kuerzel = form.control('kuerzel').value as String;
      final klassenIds = form.control('klassenIds').value as List<String>;

      if (widget.fach == null) {
        // Create new fach
        await faecherProvider.createFach(name, kuerzel, klassenIds);
      } else {
        // Update existing fach
        await faecherProvider.updateFach(
          widget.fach!.id,
          name,
          kuerzel,
          klassenIds,
        );
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Speichern: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _cancel() {
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    if (isMobile) {
      return _buildMobileLayout();
    } else {
      return _buildDesktopLayout();
    }
  }

  Widget _buildMobileLayout() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.9,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.fach == null ? 'Neues Fach' : 'Fach bearbeiten'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _cancel,
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
                _buildFormContent(),
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
                    onPressed: _cancel,
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
                        onPressed: (isValid && !_isLoading) ? _saveFach : null,
                        icon: _isLoading 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(widget.fach == null ? Icons.add : Icons.save),
                        label: Text(widget.fach == null ? 'Erstellen' : 'Speichern'),
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

  Widget _buildDesktopLayout() {
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
                      widget.fach == null ? Icons.add : Icons.edit,
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
                          widget.fach == null ? 'Neues Fach' : 'Fach bearbeiten',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.fach == null ? 'Ein neues Fach erstellen' : 'Fachinformationen ändern',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _cancel,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Flexible(
                child: SingleChildScrollView(
                  child: _buildFormContent(),
                ),
              ),

              const SizedBox(height: 24),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _cancel,
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
                          onPressed: (isValid && !_isLoading) ? _saveFach : null,
                          icon: _isLoading 
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(widget.fach == null ? Icons.add : Icons.save),
                          label: Text(widget.fach == null ? 'Erstellen' : 'Speichern'),
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

  Widget _buildFormContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Fach Name Field
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
            
            return ReactiveFormField<List<String>, List<String>>(
              formControlName: 'klassenIds',
              builder: (field) {
                final selectedIds = field.value ?? <String>[];
                
                return Column(
                  children: [
                    // Selected classes chips
                    if (selectedIds.isNotEmpty) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 8,
                          children: selectedIds.map((klasseId) {
                            final klasse = allKlassen.firstWhere(
                              (k) => k.id == klasseId,
                              orElse: () => Klasse(
                                id: klasseId,
                                name: 'Unbekannt',
                                schuljahr: '',
                                erstelltAm: DateTime.now(),
                              ),
                            );
                            
                            return Chip(
                              label: Text(klasse.name),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () {
                                final newList = List<String>.from(selectedIds)
                                  ..remove(klasseId);
                                field.didChange(newList);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    
                    // Available classes to add
                    Container(
                      width: double.infinity,
                      height: 300, // Feste Höhe für Scrollbereich
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Scrollbar(
                        thumbVisibility: true, // Scrollbar immer sichtbar
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
      ],
    );
  }
}
