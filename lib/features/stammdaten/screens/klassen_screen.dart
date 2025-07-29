import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/klasse.dart';
import '../providers/klassen_provider.dart';
import '../widgets/klasse_dialog_temp.dart';

class KlassenScreen extends StatefulWidget {
  const KlassenScreen({super.key});

  @override
  State<KlassenScreen> createState() => _KlassenScreenState();
}

class _KlassenScreenState extends State<KlassenScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  String _selectedSchuljahr = 'Alle';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KlassenProvider>().loadKlassen();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Klasse> _getFilteredKlassen(List<Klasse> klassen) {
    return klassen.where((klasse) {
      final matchesSearch = klasse.name.toLowerCase().contains(_searchTerm.toLowerCase());
      final matchesSchuljahr = _selectedSchuljahr == 'Alle' || klasse.schuljahr == _selectedSchuljahr;
      return matchesSearch && matchesSchuljahr && !klasse.istArchiviert;
    }).toList();
  }

  Set<String> _getSchuljahre(List<Klasse> klassen) {
    return klassen.map((k) => k.schuljahr).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive Layout basierend auf verfügbarer Höhe und Breite
          final isSmallScreen = constraints.maxHeight < 600;
          final isNarrowScreen = constraints.maxWidth < 600;
          
          return Column(
            children: [
              // Header mit Titel und Actions - responsive
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: isNarrowScreen 
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.class_,
                              size: isSmallScreen ? 24 : 32,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Klassen-Verwaltung',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontSize: isSmallScreen ? 18 : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showKlasseDialog(),
                            icon: const Icon(Icons.add),
                            label: const Text('Neue Klasse'),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Icon(
                          Icons.class_,
                          size: isSmallScreen ? 24 : 32,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Klassen-Verwaltung',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: isSmallScreen ? 18 : null,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () => _showKlasseDialog(),
                          icon: const Icon(Icons.add),
                          label: const Text('Neue Klasse'),
                        ),
                      ],
                    ),
              ),

              // Filter & Suche - responsive
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                child: isNarrowScreen 
                  ? Column(
                      children: [
                        // Suchfeld
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Klasse suchen...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            suffixIcon: _searchTerm.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchTerm = '';
                                      });
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchTerm = value;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        // Schuljahr Filter
                        SizedBox(
                          width: double.infinity,
                          child: Consumer<KlassenProvider>(
                            builder: (context, provider, child) {
                              final schuljahre = _getSchuljahre(provider.klassen);
                              return DropdownButton<String>(
                                value: _selectedSchuljahr,
                                hint: const Text('Schuljahr'),
                                isExpanded: true,
                                items: [
                                  const DropdownMenuItem(value: 'Alle', child: Text('Alle Schuljahre')),
                                  ...schuljahre.map((jahr) => DropdownMenuItem(
                                        value: jahr,
                                        child: Text(jahr),
                                      )),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSchuljahr = value ?? 'Alle';
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        // Suchfeld
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Klasse suchen...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              suffixIcon: _searchTerm.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {
                                          _searchTerm = '';
                                        });
                                      },
                                    )
                                  : null,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchTerm = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Schuljahr Filter
                        Consumer<KlassenProvider>(
                          builder: (context, provider, child) {
                            final schuljahre = _getSchuljahre(provider.klassen);
                            return DropdownButton<String>(
                              value: _selectedSchuljahr,
                              hint: const Text('Schuljahr'),
                              items: [
                                const DropdownMenuItem(value: 'Alle', child: Text('Alle Schuljahre')),
                                ...schuljahre.map((jahr) => DropdownMenuItem(
                                      value: jahr,
                                      child: Text(jahr),
                                    )),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedSchuljahr = value ?? 'Alle';
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
              ),

              // Tabelle - responsive mit besserer Anpassung für kleine Bildschirme
              Expanded(
                child: Consumer<KlassenProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final filteredKlassen = _getFilteredKlassen(provider.klassen);

                    if (filteredKlassen.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.class_,
                                size: isSmallScreen ? 48 : 64,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              SizedBox(height: isSmallScreen ? 12 : 16),
                              Text(
                                _searchTerm.isNotEmpty 
                                    ? 'Keine Klassen gefunden'
                                    : 'Noch keine Klassen vorhanden',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _searchTerm.isNotEmpty 
                                    ? 'Versuchen Sie einen anderen Suchbegriff'
                                    : 'Erstellen Sie Ihre erste Klasse',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (_searchTerm.isEmpty) ...[
                                SizedBox(height: isSmallScreen ? 16 : 24),
                                ElevatedButton.icon(
                                  onPressed: () => _showKlasseDialog(),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Erste Klasse erstellen'),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }

                    // Verwende ListView für schmale Bildschirme, DataTable für breite
                    if (isNarrowScreen) {
                      return ListView.builder(
                        padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                        itemCount: filteredKlassen.length,
                        itemBuilder: (context, index) {
                          final klasse = filteredKlassen[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.class_,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              title: Text(
                                klasse.name,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Schuljahr: ${klasse.schuljahr}'),
                                  Text(
                                    'Erstellt: ${_formatDate(klasse.erstelltAm)}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () => _showKlasseDialog(klasse: klasse),
                                    icon: const Icon(Icons.edit),
                                    tooltip: 'Bearbeiten',
                                  ),
                                  IconButton(
                                    onPressed: () => _confirmDelete(klasse),
                                    icon: const Icon(Icons.delete),
                                    tooltip: 'Löschen',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 24,
                            columns: [
                              const DataColumn(
                                label: Text(
                                  'Klasse',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const DataColumn(
                                label: Text(
                                  'Schuljahr',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const DataColumn(
                                label: Text(
                                  'Erstellt am',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const DataColumn(
                                label: Text(
                                  'Aktionen',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            rows: filteredKlassen.map((klasse) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primaryContainer,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.class_,
                                            size: 20,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                klasse.name,
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                'ID: ${klasse.id.length > 8 ? '${klasse.id.substring(0, 8)}...' : klasse.id}',
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: Theme.of(context).colorScheme.outline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8, 
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.secondaryContainer,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        klasse.schuljahr,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      _formatDate(klasse.erstelltAm),
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () => _showKlasseDialog(klasse: klasse),
                                          tooltip: 'Bearbeiten',
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete_outline,
                                            color: Theme.of(context).colorScheme.error,
                                          ),
                                          onPressed: () => _confirmDelete(klasse),
                                          tooltip: 'Löschen',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  Future<void> _showKlasseDialog({Klasse? klasse}) async {
    // Check if we're on a mobile device
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    if (isMobile) {
      // Show as fullscreen bottom sheet on mobile
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        builder: (context) => KlasseDialog.mobile(klasse: klasse),
      );
    } else {
      // Show as standard dialog on desktop
      await showDialog<void>(
        context: context,
        builder: (context) => KlasseDialog.desktop(klasse: klasse),
      );
    }
  }

  Future<void> _confirmDelete(Klasse klasse) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Klasse löschen'),
        content: Text('Möchten Sie die Klasse "${klasse.name}" wirklich löschen?\n\nDiese Aktion kann nicht rückgängig gemacht werden.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await context.read<KlassenProvider>().deleteKlasse(klasse.id);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Klasse "${klasse.name}" wurde gelöscht'),
              action: SnackBarAction(
                label: 'Rückgängig',
                onPressed: () async {
                  try {
                    await context.read<KlassenProvider>().restoreKlasse(klasse.id);
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Fehler beim Wiederherstellen: $e'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fehler beim Löschen: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }
}
