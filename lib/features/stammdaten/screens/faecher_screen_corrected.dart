import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/stammdaten_view.dart';
import '../models/fach.dart';
import '../models/klasse.dart';
import '../dtos/fach_dtos.dart';
import '../dtos/klasse_dtos.dart';
import '../providers/refactored_faecher_provider.dart';
import '../providers/refactored_klassen_provider.dart';
import '../widgets/fach_dialog_refactored.dart';
import '../widgets/stammdaten_list_item.dart';

class FaecherScreen extends StatefulWidget {
  const FaecherScreen({super.key});

  @override
  State<FaecherScreen> createState() => _FaecherScreenState();
}

class _FaecherScreenState extends State<FaecherScreen> {
  String _searchTerm = '';
  String _selectedSchuljahr = 'Alle Schuljahre';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final faecherProvider = Provider.of<RefactoredFaecherProvider>(context, listen: false);
    final klassenProvider = Provider.of<RefactoredKlassenProvider>(context, listen: false);
    
    await Future.wait([
      faecherProvider.loadFaecher(),
      klassenProvider.loadKlassen(),
    ]);
  }

  // Helper methods to convert DTOs to Domain models
  Fach _faecherResponseToModel(FachResponse response) {
    return Fach(
      id: response.id,
      name: response.name,
      kuerzel: response.kuerzel,
      klassenIds: List.from(response.klassenIds),
      erstelltAm: response.erstelltAm,
    );
  }

  Klasse _klassenResponseToModel(KlasseResponse response) {
    return Klasse(
      id: response.id,
      name: response.name,
      schuljahr: response.schuljahr,
      erstelltAm: response.erstelltAm,
      istArchiviert: response.istArchiviert,
    );
  }

  List<Fach> _getFilteredFaecher(List<Fach> faecher, List<Klasse> klassen) {
    return faecher.where((fach) {
      final matchesSearch = fach.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
                          fach.kuerzel.toLowerCase().contains(_searchTerm.toLowerCase());
      
      if (_selectedSchuljahr == 'Alle Schuljahre') {
        return matchesSearch;
      }
      
      // Filter by Schuljahr - check if fach has classes in selected Schuljahr
      final fachKlassen = klassen.where((k) => fach.klassenIds.contains(k.id));
      final hasSchuljahrMatch = fachKlassen.any((k) => k.schuljahr == _selectedSchuljahr);
      
      return matchesSearch && hasSchuljahrMatch;
    }).toList();
  }

  List<String> _getSchuljahrOptions(List<Klasse> klassen) {
    final schuljahre = klassen.map((k) => k.schuljahr).toSet().toList();
    schuljahre.sort();
    return ['Alle Schuljahre', ...schuljahre];
  }

  List<String> _getKlassenNames(Fach fach, List<Klasse> klassen) {
    return fach.klassenIds
        .map((id) => klassen.firstWhere((k) => k.id == id, orElse: () => Klasse(
              id: id, 
              name: 'Unbekannt', 
              schuljahr: '', 
              erstelltAm: DateTime.now()
            )).name)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RefactoredFaecherProvider, RefactoredKlassenProvider>(
      builder: (context, faecherProvider, klassenProvider, child) {
        final faecher = faecherProvider.faecher.map(_faecherResponseToModel).toList();
        final klassen = klassenProvider.klassen.map(_klassenResponseToModel).toList();
        final filteredFaecher = _getFilteredFaecher(faecher, klassen);
        final schuljahre = _getSchuljahrOptions(klassen);

        return StammdatenView<Fach>(
          title: 'Fächer-Verwaltung',
          items: filteredFaecher,
          searchHint: 'Fächer durchsuchen...',
          onSearch: (value) {
            setState(() {
              _searchTerm = value;
            });
          },
          selectedSchuljahr: _selectedSchuljahr,
          schuljahre: schuljahre,
          onSchuljahrChanged: (value) {
            setState(() {
              _selectedSchuljahr = value ?? 'Alle Schuljahre';
            });
          },
          onAdd: () => _showAddDialog(context),
          itemBuilder: (context, fach, index) {
            final klassenNames = _getKlassenNames(fach, klassen);
            
            return StammdatenListItem<Fach>(
              item: fach,
              title: '${fach.name} (${fach.kuerzel})',
              subtitle: klassenNames.isNotEmpty 
                ? Text('Klassen: ${klassenNames.join(', ')}')
                : const Text('Keine Klassen zugeordnet', style: TextStyle(color: Colors.grey)),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.subject,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 20,
                ),
              ),
              onTap: () => _showEditDialog(context, fach),
              onEdit: () => _showEditDialog(context, fach),
              onDelete: () => _showDeleteDialog(context, fach),
            );
          },
          isLoading: faecherProvider.isLoading || klassenProvider.isLoading,
          emptyMessage: _searchTerm.isNotEmpty || _selectedSchuljahr != 'Alle Schuljahre'
              ? 'Keine Fächer gefunden'
              : 'Noch keine Fächer erstellt',
          floatingActionButtonTooltip: 'Neues Fach hinzufügen',
        );
      },
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => isMobile
        ? const FachDialogRefactored.mobile()
        : const FachDialogRefactored.desktop(),
    );

    if (result == true && mounted) {
      // Dialog wurde erfolgreich gespeichert, keine weitere Aktion nötig
      // da der Provider bereits aktualisiert wurde
    }
  }

  Future<void> _showEditDialog(BuildContext context, Fach fach) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => isMobile
        ? FachDialogRefactored.mobile(item: fach)
        : FachDialogRefactored.desktop(item: fach),
    );

    if (result == true && mounted) {
      // Dialog wurde erfolgreich gespeichert, keine weitere Aktion nötig
      // da der Provider bereits aktualisiert wurde
    }
  }

  void _showDeleteDialog(BuildContext context, Fach fach) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fach löschen'),
        content: Text('Möchten Sie das Fach "${fach.name}" wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await context.read<RefactoredFaecherProvider>().deleteFach(fach.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Fach "${fach.name}" wurde gelöscht'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Fehler beim Löschen: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
  }
}
