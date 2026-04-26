import 'package:flutter_test/flutter_test.dart';

import 'package:uts_pemrogramanmobile/main.dart';

void main() {
  testWidgets('Login page appears and can navigate to home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Home - Lost & Found ITG'), findsOneWidget);
  });
}
