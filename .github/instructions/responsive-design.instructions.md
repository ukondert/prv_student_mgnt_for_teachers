---
applyTo: "**/*.dart"
---

# Flutter Cross-Platform Design Instructions

## Responsive Design Patterns

### Breakpoints
- **Mobile**: < 600px width (use ListView, Cards, NavigationBar)
- **Tablet**: 600-1024px width (hybrid approach, NavigationRail)  
- **Desktop**: > 1024px width (use DataTable, NavigationRail, multi-column)

### Adaptive Layouts

```dart
// PREFERRED: Use LayoutBuilder for responsive design
LayoutBuilder(
  builder: (context, constraints) {
    final isSmallScreen = constraints.maxWidth < 600;
    final isNarrowScreen = constraints.maxWidth < 600;
    
    if (isNarrowScreen) {
      return MobileLayout(); // ListView with Cards
    } else {
      return DesktopLayout(); // DataTable with full features
    }
  },
)

// AVOID: Fixed layouts that don't adapt
DataTable(...) // This breaks on mobile!
```

### Navigation Patterns

```dart
// Mobile: BottomNavigationBar
// Desktop/Tablet: NavigationRail
final isDesktop = MediaQuery.of(context).size.width >= 600;

if (isDesktop) {
  return NavigationRail(...);
} else {
  return BottomNavigationBar(...);
}
```

### Dialog Patterns

```dart
// PREFERRED: Responsive Dialogs
Future<void> _showResponsiveDialog(BuildContext context, {required bool isMobile}) async {
  if (isMobile) {
    // Mobile: Full-height BottomSheet with handle bar
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      height: MediaQuery.of(context).size.height * 0.9,
      // ... mobile-optimized content
    );
  } else {
    // Desktop: Standard AlertDialog with fixed width
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(width: 400, child: ...),
        // ... desktop-optimized content
      ),
    );
  }
}

// AVOID: Fixed dialog sizes that don't adapt
AlertDialog(...) // This breaks UX on mobile!
```

## UI Components Rules

### Data Display
- **Mobile**: ListView.builder with Card widgets for performance
- **Desktop**: DataTable with horizontal scroll if needed
- **Touch Targets**: Minimum 44px height for mobile interactions

### Form Elements
- **Mobile**: Full-width inputs, large buttons, more spacing
- **Desktop**: Constrained width (max 400px), hover states

### Dialog & Modal Guidelines
- **Mobile**: 
  - Use BottomSheet for forms/content (90% screen height)
  - Add handle bar for swipe-to-dismiss
  - Sticky action buttons at bottom
  - Larger touch targets (48px minimum)
- **Desktop**: 
  - Use AlertDialog with fixed width (400px)
  - Standard dialog actions in footer
  - Keyboard navigation support

### Typography
- **Mobile**: Larger text sizes (16px minimum for body text)
- **Desktop**: Smaller text acceptable (14px body text)

## Performance Guidelines

### ListView Best Practices
```dart
// PREFERRED: Use builder for large lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ItemWidget(items[index]);
  },
)

// AVOID: Creating all items at once
ListView(
  children: items.map((item) => ItemWidget(item)).toList(),
)
```

### State Management
- Use Provider/Riverpod for responsive state
- Implement proper disposal of controllers
- Cache expensive calculations

## Error Prevention

### Common BoxConstraints Issues
- Always provide bounded height for DataTable in Column
- Use Expanded or Flexible in scrollable contexts
- Test on different screen sizes

### Example Solution for DataTable
```dart
// CORRECT: Bounded DataTable
Expanded(
  child: SingleChildScrollView(
    child: DataTable(...),
  ),
)

// WRONG: Unbounded DataTable
Column(
  children: [
    DataTable(...), // RenderFlex overflow!
  ],
)
```

## Testing Requirements
- Test on multiple screen sizes (mobile, tablet, desktop)
- Verify touch targets on mobile devices
- Check horizontal overflow on narrow screens
- Validate performance with large datasets
