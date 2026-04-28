import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uts_pemrogramanmobile/main.dart';

void main() {
  testWidgets(
    'Login form shows validation errors then navigates on valid input',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('Masuk'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Email wajib diisi'), findsOneWidget);
      expect(find.text('Password wajib diisi'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).at(0), 'invalid-email');
      await tester.enterText(find.byType(TextFormField).at(1), '123');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Format email tidak valid'), findsOneWidget);
      expect(find.text('Password minimal 6 karakter'), findsOneWidget);

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'mahasiswa@itg.ac.id',
      );
      await tester.enterText(find.byType(TextFormField).at(1), '123456');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Home - Lost & Found ITG'), findsOneWidget);

      // Tap logout and expect to return to Login screen
      await tester.tap(find.byTooltip('Logout'));
      await tester.pumpAndSettle();

      expect(find.text('Masuk'), findsOneWidget);
    },
  );
}
