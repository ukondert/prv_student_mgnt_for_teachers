// Adaptive Widgets - Platform-spezifische UI-Komponenten
// Zeigt wie man mit einer Codebasis verschiedene Plattformen unterstützt

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Platform-adaptive Button
/// Zeigt Material Button auf Android/Web, Cupertino Button auf iOS
class AdaptiveButton extends StatelessWidget {
  const AdaptiveButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoButton(
        onPressed: onPressed,
        child: child,
      );
    }
    
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: child,
    );
  }
}

/// Platform-adaptive Loading Indicator
class AdaptiveProgressIndicator extends StatelessWidget {
  const AdaptiveProgressIndicator({
    super.key,
    this.value,
  });

  final double? value;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return const CupertinoActivityIndicator();
    }
    
    return CircularProgressIndicator(value: value);
  }
}

/// Platform-adaptive Alert Dialog
class AdaptiveAlertDialog extends StatelessWidget {
  const AdaptiveAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  final String title;
  final String content;
  final List<AdaptiveDialogAction> actions;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions.map((action) {
          return CupertinoDialogAction(
            isDefaultAction: action.isDefault,
            isDestructiveAction: action.isDestructive,
            onPressed: action.onPressed,
            child: Text(action.text),
          );
        }).toList(),
      );
    }
    
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actions.map((action) {
        return TextButton(
          onPressed: action.onPressed,
          child: Text(action.text),
        );
      }).toList(),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String content,
    required List<AdaptiveDialogAction> actions,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AdaptiveAlertDialog(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }
}

class AdaptiveDialogAction {
  const AdaptiveDialogAction({
    required this.text,
    required this.onPressed,
    this.isDefault = false,
    this.isDestructive = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isDefault;
  final bool isDestructive;
}

/// Adaptive Navigation - Platform-spezifische Navigation Patterns
class AdaptiveScaffold extends StatefulWidget {
  const AdaptiveScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(widget.title),
          trailing: widget.actions != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.actions!,
                )
              : null,
        ),
        child: SafeArea(child: widget.body),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: widget.actions,
      ),
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}

/// Responsive Form Layout - Anpassung an verschiedene Bildschirmgrößen
class ResponsiveFormScreen extends StatefulWidget {
  const ResponsiveFormScreen({super.key});

  @override
  State<ResponsiveFormScreen> createState() => _ResponsiveFormScreenState();
}

class _ResponsiveFormScreenState extends State<ResponsiveFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      title: 'Responsive Form',
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;
          
          return SingleChildScrollView(
            padding: EdgeInsets.all(isWideScreen ? 32 : 16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Form(
                  key: _formKey,
                  child: isWideScreen 
                      ? _buildWideLayout()
                      : _buildNarrowLayout(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildNameField(),
        const SizedBox(height: 16),
        _buildEmailField(),
        const SizedBox(height: 16),
        _buildPhoneField(),
        const SizedBox(height: 16),
        _buildAddressField(),
        const SizedBox(height: 32),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildWideLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // First row: Name and Email
        Row(
          children: [
            Expanded(child: _buildNameField()),
            const SizedBox(width: 16),
            Expanded(child: _buildEmailField()),
          ],
        ),
        const SizedBox(height: 16),
        // Second row: Phone
        _buildPhoneField(),
        const SizedBox(height: 16),
        // Third row: Address
        _buildAddressField(),
        const SizedBox(height: 32),
        // Submit button centered
        Center(
          child: SizedBox(
            width: 200,
            child: _buildSubmitButton(),
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(
        labelText: 'Phone',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.phone),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        return null;
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: const InputDecoration(
        labelText: 'Address',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.location_on),
      ),
      maxLines: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your address';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return AdaptiveButton(
      onPressed: _submitForm,
      child: const Text('Submit'),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      AdaptiveAlertDialog.show(
        context,
        title: 'Form Submitted',
        content: 'Your form has been submitted successfully!',
        actions: [
          AdaptiveDialogAction(
            text: 'OK',
            isDefault: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    }
  }
}

/// Adaptive Navigation mit verschiedenen Patterns je nach Plattform
class AdaptiveNavigation extends StatefulWidget {
  const AdaptiveNavigation({super.key});

  @override
  State<AdaptiveNavigation> createState() => _AdaptiveNavigationState();
}

class _AdaptiveNavigationState extends State<AdaptiveNavigation> {
  int _currentIndex = 0;

  final List<NavigationItem> _items = [
    NavigationItem(
      icon: Icons.home,
      label: 'Home',
      widget: const HomeTab(),
    ),
    NavigationItem(
      icon: Icons.search,
      label: 'Search',
      widget: const SearchTab(),
    ),
    NavigationItem(
      icon: Icons.favorite,
      label: 'Favorites',
      widget: const FavoritesTab(),
    ),
    NavigationItem(
      icon: Icons.person,
      label: 'Profile',
      widget: const ProfileTab(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 800;
    
    if (isWideScreen) {
      return _buildDesktopLayout();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _buildIOSLayout();
    } else {
      return _buildMaterialLayout();
    }
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: _items.map((item) {
              return NavigationRailDestination(
                icon: Icon(item.icon),
                label: Text(item.label),
              );
            }).toList(),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: _items[_currentIndex].widget,
          ),
        ],
      ),
    );
  }

  Widget _buildIOSLayout() {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: _items.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
          );
        }).toList(),
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) => _items[index].widget,
        );
      },
    );
  }

  Widget _buildMaterialLayout() {
    return Scaffold(
      body: _items[_currentIndex].widget,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _items.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class NavigationItem {
  const NavigationItem({
    required this.icon,
    required this.label,
    required this.widget,
  });

  final IconData icon;
  final String label;
  final Widget widget;
}

// Tab Widgets
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      title: 'Home',
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 64),
            SizedBox(height: 16),
            Text('Home Tab', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      title: 'Search',
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64),
            SizedBox(height: 16),
            Text('Search Tab', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      title: 'Favorites',
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, size: 64),
            SizedBox(height: 16),
            Text('Favorites Tab', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      title: 'Profile',
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 64),
            SizedBox(height: 16),
            Text('Profile Tab', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
