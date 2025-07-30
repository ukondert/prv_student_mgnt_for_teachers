import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/list_item_widget.dart';
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
  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
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

  Future<void> _showFachDialog({Fach? fach}) async {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => isMobile 
        ? FachDialog.mobile(fach: fach)
        : FachDialog.desktop(fach: fach),
    );

    if (result == true) {
      // Refresh data after successful save
      await _loadData();
    }
  }

  Future<void> _deleteFach(Fach fach) async {
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
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await Provider.of<FaecherProvider>(context, listen: false)
            .deleteFach(fach.id);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fach "${fach.name}" wurde gelöscht'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fehler beim Löschen: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrowScreen = constraints.maxWidth < 600;
          
          return Consumer2<FaecherProvider, KlassenProvider>(
            builder: (context, faecherProvider, klassenProvider, child) {
              if (faecherProvider.isLoading || klassenProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final faecher = faecherProvider.faecher;
              final klassenMap = {
                for (var klasse in klassenProvider.klassen) klasse.id: klasse
              };

              if (faecher.isEmpty) {
                return _buildEmptyState();
              }

              if (isNarrowScreen) {
                return _buildMobileLayout(faecher, klassenMap);
              } else {
                return _buildDesktopLayout(faecher, klassenMap);
              }
            },
          );
        },
      ),
      // FAB nur auf Mobile/schmalen Bildschirmen anzeigen
      floatingActionButton: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrowScreen = constraints.maxWidth < 600;
          
          if (isNarrowScreen) {
            return FloatingActionButton(
              onPressed: () => _showFachDialog(),
              tooltip: 'Neues Fach',
              child: const Icon(Icons.add),
            );
          } else {
            // Kein FAB auf Desktop - Button ist in der Toolbar
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.subject,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Keine Fächer vorhanden',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Erstellen Sie Ihr erstes Fach mit dem + Button',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _showFachDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Erstes Fach erstellen'),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(List<Fach> faecher, Map<String, Klasse> klassenMap) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faecher.length,
        itemBuilder: (context, index) {
          final fach = faecher[index];
          final zugeordneteKlassen = fach.klassenIds
              .map((id) => klassenMap[id]?.name ?? 'Unbekannt')
              .toList();

          return ListItemWidget(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.subject,
                color: Colors.white,
              ),
            ),
            title: fach.name,
            badge: KuerzelBadge(kuerzel: fach.kuerzel),
            subtitle: KlassenChipsWidget(klassenNames: zugeordneteKlassen),
            onTap: () => _showFachDialog(fach: fach),
            onEdit: () => _showFachDialog(fach: fach),
            onDelete: () => _deleteFach(fach),
          );
        },
      ),
    );
  }

  Widget _buildDesktopLayout(List<Fach> faecher, Map<String, Klasse> klassenMap) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Fächer-Verwaltung',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => _showFachDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Neues Fach'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DataTable(
            headingRowHeight: 56,
            // dataRowMinHeight entfernt wegen BoxConstraints-Problemen auf Windows
            columns: const [
              DataColumn(
                label: Text(
                  'Fach-Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Kürzel',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Zugeordnete Klassen',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Erstellt am',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Aktionen',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows: faecher.map((fach) {
              final zugeordneteKlassen = fach.klassenIds
                  .map((id) => klassenMap[id]?.name ?? 'Unbekannt')
                  .toList();

              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      fach.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onTap: () => _showFachDialog(fach: fach),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        fach.kuerzel,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    zugeordneteKlassen.isNotEmpty
                        ? Wrap(
                            spacing: 4,
                            children: zugeordneteKlassen.map((klassenName) {
                              return Chip(
                                label: Text(klassenName),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              );
                            }).toList(),
                          )
                        : const Text(
                            'Keine Klassen',
                            style: TextStyle(color: Colors.grey),
                          ),
                  ),
                  DataCell(
                    Text(
                      '${fach.erstelltAm.day}.${fach.erstelltAm.month}.${fach.erstelltAm.year}',
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Bearbeiten',
                          onPressed: () => _showFachDialog(fach: fach),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Löschen',
                          onPressed: () => _deleteFach(fach),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
