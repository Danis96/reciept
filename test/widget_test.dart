import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reciep/database/app_database.dart';

import 'package:reciep/app/app_root.dart';

void main() {
  testWidgets('shows bottom navigation tabs', (WidgetTester tester) async {
    final AppDatabase testDatabase = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(AppRoot(database: testDatabase));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Scan'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
