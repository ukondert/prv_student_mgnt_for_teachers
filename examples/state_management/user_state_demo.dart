// State Management Beispiele - Verschiedene Patterns für Flutter Apps
// Zeigt moderne Ansätze für State Management in Flutter

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// User Model - immutable data class
@immutable
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final bool isActive;

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// App State - immutable state container
@immutable
class AppState {
  const AppState({
    this.users = const [],
    this.selectedUser,
    this.isLoading = false,
    this.error,
  });

  final List<User> users;
  final User? selectedUser;
  final bool isLoading;
  final String? error;

  AppState copyWith({
    List<User>? users,
    User? selectedUser,
    bool? isLoading,
    String? error,
  }) {
    return AppState(
      users: users ?? this.users,
      selectedUser: selectedUser ?? this.selectedUser,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  AppState clearError() {
    return copyWith(error: null);
  }

  AppState clearSelection() {
    return copyWith(selectedUser: null);
  }
}

/// Change Notifier Pattern - für einfache State Management
class UserNotifier extends ChangeNotifier {
  AppState _state = const AppState();
  AppState get state => _state;

  List<User> get users => _state.users;
  User? get selectedUser => _state.selectedUser;
  bool get isLoading => _state.isLoading;
  String? get error => _state.error;

  void _updateState(AppState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Lädt Benutzer (simuliert async operation)
  Future<void> loadUsers() async {
    _updateState(_state.copyWith(isLoading: true, error: null));

    try {
      // Simuliere API Call
      await Future.delayed(const Duration(seconds: 1));
      
      final users = List.generate(10, (index) {
        return User(
          id: 'user_$index',
          name: 'User ${index + 1}',
          email: 'user${index + 1}@example.com',
          avatarUrl: 'https://picsum.photos/seed/$index/100/100',
        );
      });

      _updateState(_state.copyWith(
        users: users,
        isLoading: false,
      ));
    } catch (error) {
      _updateState(_state.copyWith(
        isLoading: false,
        error: 'Failed to load users: $error',
      ));
    }
  }

  /// Fügt einen neuen Benutzer hinzu
  Future<void> addUser(User user) async {
    _updateState(_state.copyWith(isLoading: true));

    try {
      // Simuliere API Call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final updatedUsers = [..._state.users, user];
      _updateState(_state.copyWith(
        users: updatedUsers,
        isLoading: false,
      ));
    } catch (error) {
      _updateState(_state.copyWith(
        isLoading: false,
        error: 'Failed to add user: $error',
      ));
    }
  }

  /// Aktualisiert einen Benutzer
  Future<void> updateUser(User updatedUser) async {
    _updateState(_state.copyWith(isLoading: true));

    try {
      // Simuliere API Call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final updatedUsers = _state.users.map((user) {
        return user.id == updatedUser.id ? updatedUser : user;
      }).toList();

      _updateState(_state.copyWith(
        users: updatedUsers,
        selectedUser: updatedUser,
        isLoading: false,
      ));
    } catch (error) {
      _updateState(_state.copyWith(
        isLoading: false,
        error: 'Failed to update user: $error',
      ));
    }
  }

  /// Löscht einen Benutzer
  Future<void> deleteUser(String userId) async {
    _updateState(_state.copyWith(isLoading: true));

    try {
      // Simuliere API Call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final updatedUsers = _state.users.where((user) => user.id != userId).toList();
      _updateState(_state.copyWith(
        users: updatedUsers,
        selectedUser: _state.selectedUser?.id == userId ? null : _state.selectedUser,
        isLoading: false,
      ));
    } catch (error) {
      _updateState(_state.copyWith(
        isLoading: false,
        error: 'Failed to delete user: $error',
      ));
    }
  }

  /// Wählt einen Benutzer aus
  void selectUser(User user) {
    _updateState(_state.copyWith(selectedUser: user));
  }

  /// Löscht die Auswahl
  void clearSelection() {
    _updateState(_state.clearSelection());
  }

  /// Löscht Fehlermeldungen
  void clearError() {
    _updateState(_state.clearError());
  }
}

/// ValueNotifier Pattern - für einfache reaktive Updates
class UserCountNotifier extends ValueNotifier<int> {
  UserCountNotifier() : super(0);

  void increment() {
    value = value + 1;
  }

  void decrement() {
    if (value > 0) {
      value = value - 1;
    }
  }

  void reset() {
    value = 0;
  }
}

/// State Management Demo Screen
class StateManagementDemo extends StatefulWidget {
  const StateManagementDemo({super.key});

  @override
  State<StateManagementDemo> createState() => _StateManagementDemoState();
}

class _StateManagementDemoState extends State<StateManagementDemo> {
  late final UserNotifier _userNotifier;
  late final UserCountNotifier _countNotifier;

  @override
  void initState() {
    super.initState();
    _userNotifier = UserNotifier();
    _countNotifier = UserCountNotifier();
  }

  @override
  void dispose() {
    _userNotifier.dispose();
    _countNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('State Management Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _userNotifier.loadUsers,
          ),
        ],
      ),
      body: Column(
        children: [
          // Error Banner
          ListenableBuilder(
            listenable: _userNotifier,
            builder: (context, child) {
              if (_userNotifier.error != null) {
                return Container(
                  width: double.infinity,
                  color: Colors.red.shade100,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _userNotifier.error!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _userNotifier.clearError,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Counter Demo (ValueNotifier)
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ValueNotifier Demo',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ValueListenableBuilder<int>(
                        valueListenable: _countNotifier,
                        builder: (context, count, child) {
                          return Text(
                            'Count: $count',
                            style: Theme.of(context).textTheme.headlineMedium,
                          );
                        },
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _countNotifier.decrement,
                            icon: const Icon(Icons.remove),
                          ),
                          IconButton(
                            onPressed: _countNotifier.increment,
                            icon: const Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: _countNotifier.reset,
                            icon: const Icon(Icons.refresh),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // User List (ChangeNotifier)
          Expanded(
            child: ListenableBuilder(
              listenable: _userNotifier,
              builder: (context, child) {
                if (_userNotifier.isLoading && _userNotifier.users.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (_userNotifier.users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.people, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text('No users found'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _userNotifier.loadUsers,
                          child: const Text('Load Users'),
                        ),
                      ],
                    ),
                  );
                }

                return Stack(
                  children: [
                    ListView.builder(
                      itemCount: _userNotifier.users.length,
                      itemBuilder: (context, index) {
                        final user = _userNotifier.users[index];
                        return UserListItem(
                          user: user,
                          isSelected: _userNotifier.selectedUser?.id == user.id,
                          onTap: () => _userNotifier.selectUser(user),
                          onEdit: () => _showEditDialog(user),
                          onDelete: () => _showDeleteDialog(user),
                        );
                      },
                    ),
                    if (_userNotifier.isLoading)
                      Container(
                        color: Colors.black26,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => UserFormDialog(
        title: 'Add User',
        onSave: (name, email) {
          final user = User(
            id: 'user_${DateTime.now().millisecondsSinceEpoch}',
            name: name,
            email: email,
          );
          _userNotifier.addUser(user);
          _countNotifier.increment();
        },
      ),
    );
  }

  void _showEditDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => UserFormDialog(
        title: 'Edit User',
        initialName: user.name,
        initialEmail: user.email,
        onSave: (name, email) {
          final updatedUser = user.copyWith(name: name, email: email);
          _userNotifier.updateUser(updatedUser);
        },
      ),
    );
  }

  void _showDeleteDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _userNotifier.deleteUser(user.id);
              _countNotifier.decrement();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// User List Item Widget
class UserListItem extends StatelessWidget {
  const UserListItem({
    super.key,
    required this.user,
    required this.isSelected,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final User user;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: user.avatarUrl != null
              ? NetworkImage(user.avatarUrl!)
              : null,
          child: user.avatarUrl == null
              ? Text(user.name.substring(0, 1).toUpperCase())
              : null,
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

/// User Form Dialog
class UserFormDialog extends StatefulWidget {
  const UserFormDialog({
    super.key,
    required this.title,
    required this.onSave,
    this.initialName,
    this.initialEmail,
  });

  final String title;
  final Function(String name, String email) onSave;
  final String? initialName;
  final String? initialEmail;

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Invalid email format';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_nameController.text.trim(), _emailController.text.trim());
      Navigator.of(context).pop();
    }
  }
}
