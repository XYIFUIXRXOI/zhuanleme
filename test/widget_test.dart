import 'package:flutter_test/flutter_test.dart';

import 'package:zhuanyixia/app.dart';

void main() {
  testWidgets('home screen renders wheel entries', (WidgetTester tester) async {
    await tester.pumpWidget(const SpinRitualApp());
    await tester.pumpAndSettle();

    expect(find.text('\u8f6c\u4e00\u4e0b'), findsOneWidget);
    expect(find.text('\u5403\u4ec0\u4e48'), findsOneWidget);
    expect(find.text('\u65f6\u95f4\u8f6c\u76d8'), findsOneWidget);
  });
}
