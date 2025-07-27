// Responsive Layout Helper - Utilities für adaptive UI Design
// Zentrale Helper-Klassen für verschiedene Bildschirmgrößen und Plattformen

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Screen Size Breakpoints für responsive Design
class ScreenBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
  static const double wideDesktop = 1920;
}

/// Screen Type Enum
enum ScreenType {
  mobile,
  tablet,
  desktop,
  wideDesktop;

  static ScreenType fromWidth(double width) {
    if (width < ScreenBreakpoints.mobile) return ScreenType.mobile;
    if (width < ScreenBreakpoints.tablet) return ScreenType.tablet;
    if (width < ScreenBreakpoints.desktop) return ScreenType.desktop;
    return ScreenType.wideDesktop;
  }
}

/// Responsive Value Provider
/// Ermöglicht es, verschiedene Werte für verschiedene Bildschirmgrößen zu definieren
class ResponsiveValue<T> {
  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
    this.wideDesktop,
  });

  final T mobile;
  final T? tablet;
  final T? desktop;
  final T? wideDesktop;

  T getValue(ScreenType screenType) {
    return switch (screenType) {
      ScreenType.mobile => mobile,
      ScreenType.tablet => tablet ?? mobile,
      ScreenType.desktop => desktop ?? tablet ?? mobile,
      ScreenType.wideDesktop => wideDesktop ?? desktop ?? tablet ?? mobile,
    };
  }

  T getValueForWidth(double width) {
    return getValue(ScreenType.fromWidth(width));
  }
}

/// Responsive Helper Extension für BuildContext
extension ResponsiveContext on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  
  ScreenType get screenType => ScreenType.fromWidth(screenWidth);
  
  bool get isMobile => screenType == ScreenType.mobile;
  bool get isTablet => screenType == ScreenType.tablet;
  bool get isDesktop => screenType == ScreenType.desktop;
  bool get isWideDesktop => screenType == ScreenType.wideDesktop;
  
  bool get isLandscape => screenWidth > screenHeight;
  bool get isPortrait => !isLandscape;
  
  /// Hilfsmethoden für responsive Werte
  T responsive<T>(ResponsiveValue<T> value) {
    return value.getValue(screenType);
  }
  
  double responsiveValue({
    required double mobile,
    double? tablet,
    double? desktop,
    double? wideDesktop,
  }) {
    return ResponsiveValue(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      wideDesktop: wideDesktop,
    ).getValue(screenType);
  }

  /// Padding und Margin Helpers
  EdgeInsets get defaultPadding => EdgeInsets.all(responsiveValue(
    mobile: 16,
    tablet: 24,
    desktop: 32,
  ));

  EdgeInsets get horizontalPadding => EdgeInsets.symmetric(
    horizontal: responsiveValue(
      mobile: 16,
      tablet: 32,
      desktop: 48,
      wideDesktop: 64,
    ),
  );

  /// Grid Column Count für responsive Grids
  int get gridColumns => responsiveValue(
    mobile: 1,
    tablet: 2,
    desktop: 3,
    wideDesktop: 4,
  ).round();

  /// Sidebar Width für Navigation
  double get sidebarWidth => responsiveValue(
    mobile: 0, // Hidden on mobile
    tablet: 280,
    desktop: 320,
    wideDesktop: 360,
  );
}

/// Responsive Widget Builder
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, ScreenType screenType) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenType = ScreenType.fromWidth(constraints.maxWidth);
        return builder(context, screenType);
      },
    );
  }
}

/// Responsive Layout Widget mit verschiedenen Layouts für verschiedene Screens
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.wideDesktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? wideDesktop;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenType) {
        return switch (screenType) {
          ScreenType.mobile => mobile,
          ScreenType.tablet => tablet ?? mobile,
          ScreenType.desktop => desktop ?? tablet ?? mobile,
          ScreenType.wideDesktop => wideDesktop ?? desktop ?? tablet ?? mobile,
        };
      },
    );
  }
}

/// Responsive Container mit adaptiver Maximale Breite
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.alignment = Alignment.center,
  });

  final Widget child;
  final ResponsiveValue<double>? maxWidth;
  final EdgeInsetsGeometry? padding;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final defaultMaxWidth = ResponsiveValue(
      mobile: double.infinity,
      tablet: 800,
      desktop: 1200,
      wideDesktop: 1400,
    );

    return Container(
      width: double.infinity,
      alignment: alignment,
      padding: padding ?? context.defaultPadding,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: (maxWidth ?? defaultMaxWidth).getValue(context.screenType),
        ),
        child: child,
      ),
    );
  }
}

/// Responsive Grid View
class ResponsiveGridView extends StatelessWidget {
  const ResponsiveGridView({
    super.key,
    required this.children,
    this.crossAxisCount,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    this.padding,
  });

  final List<Widget> children;
  final ResponsiveValue<int>? crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final defaultCrossAxisCount = ResponsiveValue(
      mobile: 1,
      tablet: 2,
      desktop: 3,
      wideDesktop: 4,
    );

    return GridView.builder(
      padding: padding ?? context.defaultPadding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (crossAxisCount ?? defaultCrossAxisCount).getValue(context.screenType),
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Adaptive Navigation basierend auf Bildschirmgröße
class AdaptiveNavigation extends StatelessWidget {
  const AdaptiveNavigation({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.showLabels = true,
  });

  final List<NavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) {
      return NavigationRail(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        labelType: showLabels 
            ? NavigationRailLabelType.all 
            : NavigationRailLabelType.none,
        destinations: destinations.map((dest) {
          return NavigationRailDestination(
            icon: dest.icon,
            selectedIcon: dest.selectedIcon,
            label: Text(dest.label),
          );
        }).toList(),
      );
    }

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: destinations,
    );
  }
}

/// Platform-adaptive Dialog
class AdaptiveDialog extends StatelessWidget {
  const AdaptiveDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
  });

  final String title;
  final Widget content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return AlertDialog(
        title: Text(title),
        content: content,
        actions: actions,
      );
    }

    // Desktop: Größerer Dialog mit mehr Platz
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: 600,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Flexible(child: content),
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget content,
    List<Widget> actions = const [],
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => AdaptiveDialog(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }
}

/// Typography Scale für responsive Text
class ResponsiveTextTheme {
  static TextStyle getHeadline(BuildContext context) {
    return TextStyle(
      fontSize: context.responsiveValue(
        mobile: 24,
        tablet: 28,
        desktop: 32,
        wideDesktop: 36,
      ),
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle getTitle(BuildContext context) {
    return TextStyle(
      fontSize: context.responsiveValue(
        mobile: 18,
        tablet: 20,
        desktop: 22,
        wideDesktop: 24,
      ),
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle getBody(BuildContext context) {
    return TextStyle(
      fontSize: context.responsiveValue(
        mobile: 14,
        tablet: 15,
        desktop: 16,
        wideDesktop: 16,
      ),
    );
  }
}

/// Responsive Text Widget
class ResponsiveText extends StatelessWidget {
  const ResponsiveText(
    this.text, {
    super.key,
    this.style = ResponsiveTextStyle.body,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final ResponsiveTextStyle style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final textStyle = switch (style) {
      ResponsiveTextStyle.headline => ResponsiveTextTheme.getHeadline(context),
      ResponsiveTextStyle.title => ResponsiveTextTheme.getTitle(context),
      ResponsiveTextStyle.body => ResponsiveTextTheme.getBody(context),
    };

    return Text(
      text,
      style: textStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

enum ResponsiveTextStyle {
  headline,
  title,
  body,
}

/// Responsive Spacing Utilities
class ResponsiveSpacing {
  static SizedBox vertical(BuildContext context, {
    double mobile = 16,
    double? tablet,
    double? desktop,
    double? wideDesktop,
  }) {
    return SizedBox(
      height: ResponsiveValue(
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
        wideDesktop: wideDesktop,
      ).getValue(context.screenType),
    );
  }

  static SizedBox horizontal(BuildContext context, {
    double mobile = 16,
    double? tablet,
    double? desktop,
    double? wideDesktop,
  }) {
    return SizedBox(
      width: ResponsiveValue(
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
        wideDesktop: wideDesktop,
      ).getValue(context.screenType),
    );
  }
}
