// Template for responsive Flutter screens that adapt to different screen sizes
// Apply to: lib/**/*_screen.dart

import 'package:flutter/material.dart';

class ResponsiveScreenTemplate extends StatefulWidget {
  const ResponsiveScreenTemplate({super.key});

  @override
  State<ResponsiveScreenTemplate> createState() => _ResponsiveScreenTemplateState();
}

class _ResponsiveScreenTemplateState extends State<ResponsiveScreenTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive breakpoints
          final isSmallScreen = constraints.maxHeight < 600;
          final isNarrowScreen = constraints.maxWidth < 600;
          final isMobile = constraints.maxWidth < 600;
          final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
          final isDesktop = constraints.maxWidth >= 1024;
          
          return Column(
            children: [
              // Header - responsive
              _buildHeader(context, isMobile, isSmallScreen),
              
              // Content - adaptive layout
              Expanded(
                child: isMobile 
                  ? _buildMobileLayout(context)
                  : _buildDesktopLayout(context, constraints),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
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
      child: isMobile 
        ? _buildMobileHeader(context, isSmallScreen)
        : _buildDesktopHeader(context),
    );
  }

  Widget _buildMobileHeader(BuildContext context, bool isSmallScreen) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.dashboard,
              size: isSmallScreen ? 24 : 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Screen Title',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
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
            onPressed: () => _showResponsiveDialog(context, isMobile: true),
            icon: const Icon(Icons.add),
            label: const Text('Primary Action'),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.dashboard,
          size: 32,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 16),
        Text(
          'Screen Title',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () => _showResponsiveDialog(context, isMobile: false),
          icon: const Icon(Icons.add),
          label: const Text('Primary Action'),
        ),
      ],
    );
  }

  // Responsive Dialog/Modal Method
  Future<void> _showResponsiveDialog(BuildContext context, {required bool isMobile}) async {
    if (isMobile) {
      // Mobile: Show as fullscreen modal or bottom sheet
      await _showMobileModal(context);
    } else {
      // Desktop: Show as dialog
      await _showDesktopDialog(context);
    }
  }

  Future<void> _showMobileModal(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Add New Item',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildFormContent(context, isMobile: true),
              ),
            ),
            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        // Save logic
                        Navigator.of(context).pop({'saved': true});
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (result != null && result['saved'] == true) {
      // Handle save result
      _handleSaveResult();
    }
  }

  Future<void> _showDesktopDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Item'),
        content: SizedBox(
          width: 400,
          child: _buildFormContent(context, isMobile: false),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // Save logic
              Navigator.of(context).pop({'saved': true});
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result['saved'] == true) {
      // Handle save result
      _handleSaveResult();
    }
  }

  Widget _buildFormContent(BuildContext context, {required bool isMobile}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Item Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(height: isMobile ? 16 : 12),
        TextField(
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          maxLines: isMobile ? 4 : 3,
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'category1', child: Text('Category 1')),
              DropdownMenuItem(value: 'category2', child: Text('Category 2')),
              DropdownMenuItem(value: 'category3', child: Text('Category 3')),
            ],
            onChanged: (value) {
              // Handle category change
            },
          ),
        ],
      ],
    );
  }

  void _handleSaveResult() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item saved successfully!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Responsive Delete Confirmation
  Future<void> _showDeleteConfirmation(BuildContext context, int index, {required bool isMobile}) async {
    bool confirmed = false;
    
    if (isMobile) {
      // Mobile: Bottom Sheet Confirmation
      confirmed = await _showMobileDeleteConfirmation(context, index) ?? false;
    } else {
      // Desktop: Dialog Confirmation
      confirmed = await _showDesktopDeleteConfirmation(context, index) ?? false;
    }

    if (confirmed) {
      _handleDeleteItem(index);
    }
  }

  Future<bool?> _showMobileDeleteConfirmation(BuildContext context, int index) async {
    return await showModalBottomSheet<bool>(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(
              Icons.delete_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Delete Item',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to delete "Item ${index + 1}"? This action cannot be undone.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                    ),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDesktopDeleteConfirmation(BuildContext context, int index) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.delete_outline,
          size: 32,
          color: Theme.of(context).colorScheme.error,
        ),
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "Item ${index + 1}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleDeleteItem(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item ${index + 1} deleted successfully!'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Undo delete logic
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Item ${index + 1} restored!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10, // Replace with actual data
      itemBuilder: (context, index) {
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
                Icons.list,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: Text('Item ${index + 1}'),
            subtitle: Text('Description for item ${index + 1}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _showResponsiveDialog(context, isMobile: true),
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: () => _showDeleteConfirmation(context, index, isMobile: true),
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context, BoxConstraints constraints) {
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth - 32,
              ),
              child: DataTable(
                columns: const [
                  DataColumn(
                    label: Text(
                      'Item',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Actions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: List.generate(10, (index) {
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
                                Icons.list,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text('Item ${index + 1}'),
                          ],
                        ),
                      ),
                      DataCell(Text('Description for item ${index + 1}')),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => _showResponsiveDialog(context, isMobile: false),
                              icon: const Icon(Icons.edit),
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              onPressed: () => _showDeleteConfirmation(context, index, isMobile: false),
                              icon: const Icon(Icons.delete),
                              tooltip: 'Delete',
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*
USAGE INSTRUCTIONS:

1. Replace `ResponsiveScreenTemplate` with your actual screen name
2. Replace the mock data (List.generate) with your actual data source
3. Customize the icons, colors, and styling to match your app theme
4. Add your specific business logic for actions (edit, delete, etc.)
5. Adjust breakpoints if needed for your specific use case

KEY FEATURES:

- Responsive Breakpoints: Automatically adapts to screen size
- Mobile-First: Cards and ListView for touch-friendly interaction
- Desktop Enhancement: DataTable with full feature set
- Performance Optimized: ListView.builder for large datasets
- Consistent Theming: Uses Material 3 design tokens
- Accessibility: Proper semantic widgets and touch targets
*/
