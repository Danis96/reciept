import 'package:flutter/material.dart';
import 'package:reciep/app/helpers/extensions/build_context_x.dart';

class BottomNavigationTabs extends StatelessWidget {
  const BottomNavigationTabs({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: context.l10n.home,
        ),
        NavigationDestination(
          icon: const Icon(Icons.center_focus_weak_outlined),
          selectedIcon: const Icon(Icons.center_focus_weak),
          label: context.l10n.scan,
        ),
        NavigationDestination(
          icon: const Icon(Icons.history_outlined),
          selectedIcon: const Icon(Icons.history),
          label: context.l10n.history,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: context.l10n.settings,
        ),
      ],
    );
  }
}
