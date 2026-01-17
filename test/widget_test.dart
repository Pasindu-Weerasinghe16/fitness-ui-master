import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_flutter/app/app.dart';

void main() {
  testWidgets('App boots smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Default tab is Programs.
    expect(find.text('Programs'), findsWidgets);
  });
}
