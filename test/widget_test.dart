import 'package:flutter_test/flutter_test.dart';

import '../lib/main.dart';

void main() {
  testWidgets('ARTBOARD Login screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ArtboardApp());

    expect(find.text('ARTBOARD'), findsOneWidget);
    expect(find.text('BOARD GAME CAFE'), findsOneWidget);
    expect(find.text('เข้าสู่ระบบ'), findsOneWidget);
    expect(find.text('ชื่อผู้ใช้'), findsOneWidget);
    expect(find.text('รหัสผ่าน'), findsOneWidget);
  });
}