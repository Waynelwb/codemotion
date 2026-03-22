import 'package:flutter_test/flutter_test.dart';
import 'package:codemotion/main.dart';

void main() {
  testWidgets('CodeMotion app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CodeMotionApp());
    expect(find.text('CodeMotion'), findsWidgets);
  });
}
