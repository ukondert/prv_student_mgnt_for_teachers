import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/list_item_widget.dart';
import '../../../shared/widgets/stammdaten_view.dart';
import '../models/fach.dart';
import '../models/klasse.dart';
import '../providers/faecher_provider.dart';
import '../providers/klassen_provider.dart';
import '../widgets/fach_dialog.dart';

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
    final faecherProvider = Provider.of<FaecherProvider>(context, listen: false);
    final klassenProvider = Provider.of<KlassenProvider>(context, listen: false);
    
    await Future.wait([
      faecherProvider.loadFaecher(),
      klassenProvider.loadKlassen(),
    ]);
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

  @override
  Widget build(BuildContext context) {
    return Consumer2<FaecherProvider, KlassenProvider>(
      builder: (context, faecherProvider, klassenProvider, child) {
        final filteredFaecher = _getFilteredFaecher(faecherProvider.faecher, klassenProvider.klassen);
        final schuljahre = _getSchuljahrOptions(klassenProvider.klassen);

        return StammdatenView<Fach>(
          title: 'Fächer-Verwaltung',
          items: filteredFaecher,
          itemBuilder: (context, fach, index) {
            return ListItemWidget(
              key: ValueKey(fach.id),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.book,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              title: fach.name,
              subtitle: Text(
                'Kürzel: ${fach.kuerzel}\nKlassen: ${_getKlassenNames(fach, klassenProvider.klassen)}\nErstellt: ${_formatDate(fach.erstelltAm)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              badge: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  fach.kuerzel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              onEdit: () => _showFachDialog(fach: fach),
              onDelete: () => _showDeleteDialog(context, fach),
            );
          },
          onAdd: () => _showFachDialog(),
          searchHint: 'Fach oder Kürzel suchen...',
          onSearch: (value) {
            setState(() {
              _searchTerm = value;
            });
          },
          isLoading: faecherProvider.isLoading || klassenProvider.isLoading,
          emptyMessage: 'Keine Fächer vorhanden\nErstellen Sie Ihr erstes Fach.',
          selectedSchuljahr: _selectedSchuljahr,
          schuljahre: schuljahre,
          onSchuljahrChanged: (value) {
            setState(() {
              _selectedSchuljahr = value ?? 'Alle Schuljahre';
            });
          },
          floatingActionButtonTooltip: 'Neues Fach erstellen',
        );
      },
    );
  }

  String _getKlassenNames(Fach fach, List<Klasse> allKlassen) {
    final klassenNames = allKlassen
        .where((k) => fach.klassenIds.contains(k.id))
        .map((k) => k.name)
        .toList();
    
    if (klassenNames.isEmpty) return 'Keine Klassen zugeordnet';
    if (klassenNames.length > 2) {
      return '${klassenNames.take(2).join(', ')} +${klassenNames.length - 2}';
    }
    return klassenNames.join(', ');
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  Future<void> _showFachDialog({Fach? fach}) async {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => isMobile 
        ? FachDialog.mobile(fach: fach)
        : FachDialog.desktop(fach: fach),
    );

    if (result == true) {
      await _loadData();
    }
  }

  Future<void> _showDeleteDialog(BuildContext context, Fach fach) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fach löschen'),
        content: Text('Möchten Sie das Fach "${fach.name}" wirklich löschen?'),
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
      await context.read<FaecherProvider>().deleteFach(fach.id);
    }
  }
}
