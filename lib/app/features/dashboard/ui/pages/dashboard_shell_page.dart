import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:refyn/app/features/history/ui/pages/history_page.dart';
import 'package:refyn/app/features/scan/ui/pages/scan_page.dart';
import 'package:refyn/app/features/settings/ui/pages/settings_page.dart';

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
        final bool isDark = Theme.of(context).brightness == Brightness.dark;
        final bool homeTab = controller.currentTabIndex == 0;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: homeTab
              ? const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark,
                  systemNavigationBarColor: Colors.transparent,
                )
              : (isDark
                    ? const SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        statusBarIconBrightness: Brightness.light,
                        statusBarBrightness: Brightness.dark,
                        systemNavigationBarColor: Colors.transparent,
                        systemNavigationBarIconBrightness: Brightness.light,
                      )
                    : const SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        statusBarIconBrightness: Brightness.dark,
                        statusBarBrightness: Brightness.light,
                        systemNavigationBarColor: Colors.transparent,
                        systemNavigationBarIconBrightness: Brightness.dark,
                      )),
          child: Scaffold(
            extendBodyBehindAppBar: true,
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
          ),
        );
      },
    );
  }
}
