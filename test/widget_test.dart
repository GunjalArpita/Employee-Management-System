import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Employee Management app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Employee Management'), findsOneWidget);
    expect(find.text('Rahul Sharma'), findsOneWidget);
  });
}