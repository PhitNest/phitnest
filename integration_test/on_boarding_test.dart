import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:phitnest/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('On Boarding Screen Test:', () {
    testWidgets('Set up test', (tester) async {
      app.testMain();
      await tester.pumpAndSettle();
    });
  });
}
