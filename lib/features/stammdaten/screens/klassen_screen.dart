import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/list_item_widget.dart';
import '../../../shared/widgets/stammdaten_view.dart';
import '../models/klasse.dart';
import '../providers/klassen_provider.dart';
import '../widgets/klasse_dialog_refactored.dart';

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
      context.read<KlassenProvider>().loadKlassen();
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

  @override
  Widget build(BuildContext context) {
    return Consumer<KlassenProvider>(
      builder: (context, provider, child) {
        final filteredKlassen = _getFilteredKlassen(provider.klassen);
        final schuljahre = _getSchuljahrOptions(provider.klassen);

        return StammdatenView<Klasse>(
          title: 'Klassen-Verwaltung',
          items: filteredKlassen,
          itemBuilder: (context, klasse, index) {
            return ListItemWidget(
              key: ValueKey(klasse.id),
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
              title: klasse.name,
              subtitle: Text(
                'Schuljahr: ${klasse.schuljahr}\nErstellt: ${_formatDate(klasse.erstelltAm)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onEdit: () => _showKlasseDialog(context, klasse: klasse),
              onDelete: () => _showDeleteDialog(context, klasse),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
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
      context.read<KlassenProvider>().loadKlassen();
    }
  }

  Future<void> _showDeleteDialog(BuildContext context, Klasse klasse) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Klasse löschen'),
        content: Text('Möchten Sie die Klasse "${klasse.name}" wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<KlassenProvider>().deleteKlasse(klasse.id);
    }
  }
}
