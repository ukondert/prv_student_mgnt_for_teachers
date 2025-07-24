// Flutter Screen Pattern Beispiel
// Stateful Widget mit State Management (Provider)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import '../widgets/user_profile_card.dart';
import '../models/user.dart';

/// Hauptbildschirm zur Anzeige einer Benutzerliste.
/// 
/// Demonstriert Flutter Best Practices:
/// - StatefulWidget für lokalen State
/// - Provider für State Management
/// - FutureBuilder für async Operations
/// - RefreshIndicator für Pull-to-Refresh
/// - FloatingActionButton für Primary Action
/// - Error Handling mit SnackBar
/// 
/// State Management Pattern:
/// - Lokaler State für UI-spezifische Daten (isLoading, searchQuery)
/// - Provider für geteilte Daten (UserService)
/// - Callbacks für Parent-Child Kommunikation
class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUsers();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  Future<void> _loadUsers() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    
    try {
      final userService = context.read<UserService>();
      await userService.loadUsers();
    } catch (error) {
      if (mounted) {
        _showErrorSnackBar('Fehler beim Laden der Benutzer: $error');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleRefresh() async {
    await _loadUsers();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        action: SnackBarAction(
          label: 'Wiederholen',
          onPressed: _loadUsers,
        ),
      ),
    );
  }

  void _navigateToUserDetail(User user) {
    Navigator.of(context).pushNamed(
      '/user-detail',
      arguments: user,
    );
  }

  void _navigateToCreateUser() {
    Navigator.of(context).pushNamed('/user-create');
  }

  Future<void> _handleDeleteUser(User user) async {
    final confirmed = await _showDeleteConfirmationDialog(user);
    if (!confirmed) return;

    try {
      final userService = context.read<UserService>();
      await userService.deleteUser(user.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${user.name} wurde gelöscht'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        _showErrorSnackBar('Fehler beim Löschen: $error');
      }
    }
  }

  Future<bool> _showDeleteConfirmationDialog(User user) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Benutzer löschen'),
        content: Text('Möchten Sie ${user.name} wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Löschen'),
          ),
        ],
      ),
    ) ?? false;
  }

  List<User> _getFilteredUsers(List<User> users) {
    if (_searchQuery.isEmpty) return users;
    
    final query = _searchQuery.toLowerCase();
    return users.where((user) =>
      user.name.toLowerCase().contains(query) ||
      user.email.toLowerCase().contains(query)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Benutzer'),
        backgroundColor: theme.colorScheme.inversePrimary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Benutzer suchen...',
              leading: const Icon(Icons.search),
              trailing: _searchQuery.isNotEmpty
                  ? [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
      body: Consumer<UserService>(
        builder: (context, userService, child) {
          if (_isLoading && userService.users.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final filteredUsers = _getFilteredUsers(userService.users);

          if (filteredUsers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _searchQuery.isNotEmpty ? Icons.search_off : Icons.people_outline,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isNotEmpty
                        ? 'Keine Benutzer gefunden'
                        : 'Noch keine Benutzer vorhanden',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (_searchQuery.isEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Fügen Sie den ersten Benutzer hinzu',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: UserProfileCard(
                    user: user,
                    onTap: () => _navigateToUserDetail(user),
                    onEdit: () => Navigator.of(context).pushNamed(
                      '/user-edit',
                      arguments: user,
                    ),
                    onDelete: () => _handleDeleteUser(user),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateUser,
        tooltip: 'Benutzer hinzufügen',
        child: const Icon(Icons.add),
      ),
    );
  }
}
