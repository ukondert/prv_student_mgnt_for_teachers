import 'package:flutter/material.dart';

/// Konfigurierbare Stammdaten-Ansicht mit einheitlichem Layout:
/// - Suchfeld oben
/// - Schuljahr-Dropdown
/// - ListView mit Daten
/// - FloatingActionButton für neue Einträge
class StammdatenView<T> extends StatefulWidget {
  const StammdatenView({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.onAdd,
    required this.searchHint,
    this.onSearch,
    this.isLoading = false,
    this.emptyMessage = 'Keine Einträge vorhanden',
    this.selectedSchuljahr,
    this.schuljahre = const ['Alle Schuljahre', '2024/25', '2023/24', '2022/23'],
    this.onSchuljahrChanged,
    this.floatingActionButtonTooltip,
  });

  /// Titel der Ansicht (z.B. "Klassen-Verwaltung")
  final String title;

  /// Liste der anzuzeigenden Items
  final List<T> items;

  /// Builder-Funktion für jedes Item in der Liste
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Callback für das Hinzufügen neuer Einträge (FAB)
  final VoidCallback onAdd;

  /// Placeholder-Text für das Suchfeld
  final String searchHint;

  /// Callback für Suchfunktionalität (optional)
  final ValueChanged<String>? onSearch;

  /// Loading-State
  final bool isLoading;

  /// Nachricht bei leerer Liste
  final String emptyMessage;

  /// Aktuell ausgewähltes Schuljahr
  final String? selectedSchuljahr;

  /// Verfügbare Schuljahre
  final List<String> schuljahre;

  /// Callback bei Schuljahr-Änderung
  final ValueChanged<String?>? onSchuljahrChanged;

  /// Tooltip für den FloatingActionButton
  final String? floatingActionButtonTooltip;

  @override
  State<StammdatenView<T>> createState() => _StammdatenViewState<T>();
}

class _StammdatenViewState<T> extends State<StammdatenView<T>> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          // Add-Button für Desktop in der AppBar
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = MediaQuery.of(context).size.width;
              if (screenWidth >= 600) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: ElevatedButton.icon(
                    onPressed: widget.onAdd,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(widget.floatingActionButtonTooltip ?? 'Hinzufügen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      foregroundColor: theme.colorScheme.onSecondary,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Suchfeld und Schuljahr-Dropdown Section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Suchfeld
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: widget.searchHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              widget.onSearch?.call('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                  ),
                  onChanged: widget.onSearch,
                ),
                const SizedBox(height: 16),
                
                // Schuljahr-Dropdown
                Row(
                  children: [
                    Icon(
                      Icons.school,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: widget.selectedSchuljahr ?? widget.schuljahre.first,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: widget.schuljahre.map((schuljahr) {
                          return DropdownMenuItem<String>(
                            value: schuljahr,
                            child: Text(schuljahr),
                          );
                        }).toList(),
                        onChanged: widget.onSchuljahrChanged,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Content Area
          Expanded(
            child: widget.isLoading
                ? const Center(child: CircularProgressIndicator())
                : widget.items.isEmpty
                    ? _buildEmptyState()
                    : _buildListView(),
          ),
        ],
      ),
      
      // FloatingActionButton (responsive)
      floatingActionButton: LayoutBuilder(
        builder: (context, constraints) {
          // Nur auf mobilen/schmalen Bildschirmen anzeigen
          if (constraints.maxWidth < 600) {
            return FloatingActionButton(
              onPressed: widget.onAdd,
              tooltip: widget.floatingActionButtonTooltip ?? 'Hinzufügen',
              child: const Icon(Icons.add),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            widget.emptyMessage,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 24),
          
          // Add Button für Desktop (bei leerem State)
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 600) {
                return ElevatedButton.icon(
                  onPressed: widget.onAdd,
                  icon: const Icon(Icons.add),
                  label: Text(widget.floatingActionButtonTooltip ?? 'Hinzufügen'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    return ListView.builder(
      padding: isMobile 
        ? const EdgeInsets.all(8)  // Mobile: Weniger Padding
        : const EdgeInsets.all(16), // Desktop: Standard Padding
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return widget.itemBuilder(context, item, index);
      },
    );
  }
}
