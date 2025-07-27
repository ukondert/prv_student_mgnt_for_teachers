// Responsive UI Beispiel - Adaptive Layout für verschiedene Bildschirmgrößen
// Demonstriert Flutter Best Practices für Multi-Platform UI

import 'package:flutter/material.dart';

/// Responsive Layout Builder für verschiedene Bildschirmgrößen
/// 
/// Demonstriert:
/// - LayoutBuilder für responsive Design
/// - MediaQuery für Geräteinformationen
/// - Adaptive Layouts (Mobile, Tablet, Desktop)
/// - Platform-spezifische UI-Anpassungen
/// 
/// Verwendung:
/// ```dart
/// ResponsiveLayout(
///   mobile: MobileLayout(),
///   tablet: TabletLayout(),
///   desktop: DesktopLayout(),
/// )
/// ```
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  // Breakpoints für verschiedene Bildschirmgrößen
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        
        if (width >= tabletBreakpoint) {
          return desktop;
        } else if (width >= mobileBreakpoint) {
          return tablet ?? desktop;
        } else {
          return mobile;
        }
      },
    );
  }

  /// Hilfsmethoden für responsive Checks
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }
}

/// Responsive User List Screen - Zeigt verschiedene Layouts je nach Bildschirmgröße
class ResponsiveUserListScreen extends StatefulWidget {
  const ResponsiveUserListScreen({super.key});

  @override
  State<ResponsiveUserListScreen> createState() => _ResponsiveUserListScreenState();
}

class _ResponsiveUserListScreenState extends State<ResponsiveUserListScreen> {
  final List<User> _users = _generateSampleUsers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive User List'),
        actions: [
          if (ResponsiveLayout.isDesktop(context))
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addUser,
            ),
        ],
      ),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
      floatingActionButton: ResponsiveLayout.isMobile(context)
          ? FloatingActionButton(
              onPressed: _addUser,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  /// Mobile Layout - Single Column List
  Widget _buildMobileLayout() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        return UserCard(
          user: _users[index],
          layout: UserCardLayout.compact,
          onTap: () => _showUserDetails(_users[index]),
        );
      },
    );
  }

  /// Tablet Layout - Two Column Grid
  Widget _buildTabletLayout() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        return UserCard(
          user: _users[index],
          layout: UserCardLayout.expanded,
          onTap: () => _showUserDetails(_users[index]),
        );
      },
    );
  }

  /// Desktop Layout - Master-Detail View
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // User List Sidebar
        SizedBox(
          width: 400,
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Users',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      return UserListTile(
                        user: _users[index],
                        onTap: () => _selectUser(_users[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // Detail View
        Expanded(
          child: Card(
            margin: const EdgeInsets.fromLTRB(0, 16, 16, 16),
            child: _selectedUser != null
                ? UserDetailView(user: _selectedUser!)
                : const Center(
                    child: Text('Select a user to view details'),
                  ),
          ),
        ),
      ],
    );
  }

  User? _selectedUser;

  void _selectUser(User user) {
    setState(() {
      _selectedUser = user;
    });
  }

  void _showUserDetails(User user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserDetailScreen(user: user),
      ),
    );
  }

  void _addUser() {
    // Add user logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add user functionality')),
    );
  }

  static List<User> _generateSampleUsers() {
    return List.generate(20, (index) {
      return User(
        id: 'user_$index',
        name: 'User ${index + 1}',
        email: 'user${index + 1}@example.com',
        avatarUrl: 'https://picsum.photos/seed/$index/100/100',
      );
    });
  }
}

/// Adaptive User Card mit verschiedenen Layout-Modi
enum UserCardLayout { compact, expanded, detailed }

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.user,
    required this.layout,
    this.onTap,
  });

  final User user;
  final UserCardLayout layout;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: switch (layout) {
            UserCardLayout.compact => _buildCompactLayout(),
            UserCardLayout.expanded => _buildExpandedLayout(),
            UserCardLayout.detailed => _buildDetailedLayout(),
          },
        ),
      ),
    );
  }

  Widget _buildCompactLayout() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: user.avatarUrl != null
              ? NetworkImage(user.avatarUrl!)
              : null,
          child: user.avatarUrl == null
              ? Text(user.name.substring(0, 1).toUpperCase())
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                user.email,
                style: const TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right),
      ],
    );
  }

  Widget _buildExpandedLayout() {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: user.avatarUrl != null
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              child: user.avatarUrl == null
                  ? Text(user.name.substring(0, 1).toUpperCase())
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Edit'),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.delete, size: 16),
              label: const Text('Delete'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailedLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: user.avatarUrl != null
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              child: user.avatarUrl == null
                  ? Text(
                      user.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(fontSize: 24),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Chip(
                    label: Text(user.isActive ? 'Active' : 'Inactive'),
                    backgroundColor: user.isActive ? Colors.green : Colors.red,
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// User List Tile für Desktop Sidebar
class UserListTile extends StatelessWidget {
  const UserListTile({
    super.key,
    required this.user,
    this.onTap,
  });

  final User user;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: user.avatarUrl != null
            ? NetworkImage(user.avatarUrl!)
            : null,
        child: user.avatarUrl == null
            ? Text(user.name.substring(0, 1).toUpperCase())
            : null,
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      onTap: onTap,
    );
  }
}

/// Detail View für Desktop Layout
class UserDetailView extends StatelessWidget {
  const UserDetailView({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: user.avatarUrl != null
                    ? NetworkImage(user.avatarUrl!)
                    : null,
                child: user.avatarUrl == null
                    ? Text(
                        user.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(fontSize: 32),
                      )
                    : null,
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(user.isActive ? 'Active' : 'Inactive'),
                      backgroundColor: user.isActive ? Colors.green : Colors.red,
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),
          Text(
            'Actions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text('Edit User'),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete),
                label: const Text('Delete User'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.email),
                label: const Text('Send Email'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Separate Detail Screen für Mobile/Tablet
class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
      body: UserDetailView(user: user),
    );
  }
}

/// User Model (falls nicht bereits vorhanden)
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
}
