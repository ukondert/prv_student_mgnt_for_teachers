import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/stammdaten_view.dart';
import '../models/klasse.dart';
import '../dtos/klasse_dtos.dart';
import '../providers/refactored_klassen_provider.dart';
import '../widgets/klasse_dialog_refactored.dart';
import '../widgets/stammdaten_list_item.dart';

class KlassenScreen extends StatefulWidget {
  const KlassenScreen({super.key});

  @override
  State<KlassenScreen> createState() => _KlassenScreenState();
}

class _KlassenScreenState extends State<KlassenScreen> {
  String _searchTerm = '';
  String _selectedSchuljahr = 'Alle Schuljahre';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RefactoredKlassenProvider>().loadKlassen();
    });
  }

  List<Klasse> _getFilteredKlassen(List<Klasse> klassen) {
    return klassen.where((klasse) {
      final matchesSearch = klasse.name.toLowerCase().contains(_searchTerm.toLowerCase());
      final matchesSchuljahr = _selectedSchuljahr == 'Alle Schuljahre' || klasse.schuljahr == _selectedSchuljahr;
      return matchesSearch && matchesSchuljahr && !klasse.istArchiviert;
    }).toList();
  }

  List<String> _getSchuljahrOptions(List<Klasse> klassen) {
    final schuljahre = klassen.map((k) => k.schuljahr).toSet().toList();
    schuljahre.sort();
    return ['Alle Schuljahre', ...schuljahre];
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  // Helper method to convert DTO to Domain model
  Klasse _responseToModel(KlasseResponse response) {
    return Klasse(
      id: response.id,
      name: response.name,
      schuljahr: response.schuljahr,
      erstelltAm: response.erstelltAm,
      istArchiviert: response.istArchiviert,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RefactoredKlassenProvider>(
      builder: (context, provider, child) {
        final klassen = provider.klassen.map(_responseToModel).toList();
        final filteredKlassen = _getFilteredKlassen(klassen);
        final schuljahre = _getSchuljahrOptions(klassen);

        return StammdatenView<Klasse>(
          title: 'Klassen-Verwaltung',
          items: filteredKlassen,
          itemBuilder: (context, klasse, index) {
            return StammdatenListItem<Klasse>(
              item: klasse,
              title: klasse.name,
              subtitle: Text(
                'Schuljahr: ${klasse.schuljahr}\nErstellt: ${_formatDate(klasse.erstelltAm)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.class_,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onTap: () => _showKlasseDialog(context, klasse: klasse),
              onEdit: () => _showKlasseDialog(context, klasse: klasse),
              onDelete: () => _showDeleteDialog(context, klasse),
              deleteLabel: 'Archivieren',
            );
          },
          onAdd: () => _showKlasseDialog(context),
          searchHint: 'Klasse suchen...',
          onSearch: (value) {
            setState(() {
              _searchTerm = value;
            });
          },
          isLoading: provider.isLoading,
          emptyMessage: 'Keine Klassen vorhanden\nErstellen Sie Ihre erste Klasse.',
          selectedSchuljahr: _selectedSchuljahr,
          schuljahre: schuljahre,
          onSchuljahrChanged: (value) {
            setState(() {
              _selectedSchuljahr = value ?? 'Alle Schuljahre';
            });
          },
          floatingActionButtonTooltip: 'Neue Klasse erstellen',
        );
      },
    );
  }

  Future<void> _showKlasseDialog(BuildContext context, {Klasse? klasse}) async {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => isMobile 
        ? KlasseDialogRefactored.mobile(item: klasse)
        : KlasseDialogRefactored.desktop(item: klasse),
    );

    if (result == true && mounted) {
      context.read<RefactoredKlassenProvider>().loadKlassen();
    }
  }

  Future<void> _showDeleteDialog(BuildContext context, Klasse klasse) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Klasse archivieren'),
        content: Text('Möchten Sie die Klasse "${klasse.name}" wirklich archivieren?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Archivieren'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<RefactoredKlassenProvider>().archiveKlasse(klasse.id);
    }
  }
}