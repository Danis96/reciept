import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/history/ui/pages/history_page.dart';
import 'package:reciep/app/features/scan/ui/pages/scan_page.dart';
import 'package:reciep/app/features/settings/ui/pages/settings_page.dart';

import '../../action_utils/dashboard_action_utils.dart';
import '../../controllers/dashboard_controller.dart';
import '../widgets/bottom_navigation_tabs.dart';
import 'home_page.dart';

class DashboardShellPage extends StatelessWidget {
  const DashboardShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardController>(
      builder: (context, controller, _) {
        return Scaffold(
          body: IndexedStack(
            index: controller.currentTabIndex,
            children: const [
              HomePage(),
              ScanPage(),
              HistoryPage(),
              SettingsPage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationTabs(
            currentIndex: controller.currentTabIndex,
            onDestinationSelected: (index) {
              DashboardActionUtils.onTabSelected(context, index);
            },
          ),
        );
      },
    );
  }
}
