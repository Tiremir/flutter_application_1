import 'package:flutter_application_1/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Main App', (tester) async {
    await tester.pumpWidget(const MainApp());

    expect(find.text('Hello World!'), findsOneWidget);
  });
}