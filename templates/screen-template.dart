// Flutter Screen Template
// Basis-Template für einen neuen Flutter Screen

import 'package:flutter/material.dart';

/// Ein Screen-Template für [SCREEN_BESCHREIBUNG].
/// 
/// Dieser Screen folgt Flutter Best Practices:
/// - Stateful Widget für Screen-State Management
/// - Scaffold mit AppBar und Body
/// - Loading States und Error Handling
/// - Navigation und Back-Button Handling
/// 
/// Beispiel Navigation:
/// ```dart
/// Navigator.of(context).push(
///   MaterialPageRoute(
///     builder: (context) => const TemplateScreen(title: 'Mein Screen'),
///   ),
/// );
/// ```
class TemplateScreen extends StatefulWidget {
  /// Erstellt einen neuen [TemplateScreen].
  const TemplateScreen({
    super.key,
    required this.title,
    this.data,
    this.showAppBar = true,
  });

  /// Der Titel des Screens.
  final String title;

  /// Optionale Daten für den Screen.
  final Map<String, dynamic>? data;

  /// Ob die AppBar angezeigt werden soll.
  final bool showAppBar;

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  
  // Lokaler State für den Screen
  final List<String> _items = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Lädt die Daten für den Screen.
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simuliere API-Call oder Datenladung
      await Future.delayed(const Duration(seconds: 1));
      
      // TODO: Echte Datenladung implementieren
      setState(() {
        _items.addAll(['Item 1', 'Item 2', 'Item 3']);
      });
      
    } catch (error) {
      setState(() {
        _errorMessage = 'Fehler beim Laden der Daten: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Behandelt Refresh-Aktionen.
  Future<void> _handleRefresh() async {
    _items.clear();
    await _loadData();
  }

  /// Zeigt eine SnackBar mit einer Nachricht.
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError 
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
        action: isError 
            ? SnackBarAction(
                label: 'Wiederholen',
                onPressed: _loadData,
              )
            : null,
      ),
    );
  }

  /// Behandelt das Hinzufügen eines neuen Items.
  void _addItem() {
    setState(() {
      _items.add('Neues Item ${_items.length + 1}');
    });
    _showSnackBar('Item hinzugefügt');
  }

  /// Behandelt das Löschen eines Items.
  void _deleteItem(int index) {
    if (index >= 0 && index < _items.length) {
      final item = _items[index];
      setState(() {
        _items.removeAt(index);
      });
      _showSnackBar('$item gelöscht');
    }
  }

  /// Navigiert zu einem Detail-Screen.
  void _navigateToDetail(String item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(item)),
          body: Center(
            child: Text('Detail für: $item'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(widget.title),
              backgroundColor: theme.colorScheme.inversePrimary,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _isLoading ? null : _handleRefresh,
                  tooltip: 'Aktualisieren',
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'settings':
                        // TODO: Zu Einstellungen navigieren
                        _showSnackBar('Einstellungen öffnen');
                        break;
                      case 'help':
                        // TODO: Hilfe anzeigen
                        _showSnackBar('Hilfe anzeigen');
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings),
                          SizedBox(width: 8),
                          Text('Einstellungen'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'help',
                      child: Row(
                        children: [
                          Icon(Icons.help),
                          SizedBox(width: 8),
                          Text('Hilfe'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          : null,
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Item hinzufügen',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Erstellt den Hauptinhalt des Screens.
  Widget _buildBody() {
    if (_isLoading && _items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Lade Daten...'),
          ],
        ),
      );
    }

    if (_errorMessage != null && _items.isEmpty) {
      return _buildErrorView();
    }

    if (_items.isEmpty) {
      return _buildEmptyView();
    }

    return _buildContentView();
  }

  /// Erstellt die Fehler-Ansicht.
  Widget _buildErrorView() {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Etwas ist schiefgelaufen',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unbekannter Fehler',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Erneut versuchen'),
            ),
          ],
        ),
      ),
    );
  }

  /// Erstellt die Leer-Ansicht.
  Widget _buildEmptyView() {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Keine Daten vorhanden',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fügen Sie das erste Item hinzu',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _addItem,
              icon: const Icon(Icons.add),
              label: const Text('Item hinzufügen'),
            ),
          ],
        ),
      ),
    );
  }

  /// Erstellt die Inhalts-Ansicht mit den Daten.
  Widget _buildContentView() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(item),
              subtitle: Text('Item #${index + 1}'),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'view':
                      _navigateToDetail(item);
                      break;
                    case 'delete':
                      _deleteItem(index);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility),
                        SizedBox(width: 8),
                        Text('Anzeigen'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Löschen', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () => _navigateToDetail(item),
            ),
          );
        },
      ),
    );
  }
}
