import 'package:phitnest_core/failure.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Failure',
    () {
      test(
        'invalid failure JSON',
        () {
          final invalidJson = {
            'typo': 'There is a typo in the key',
            'message': 'hey',
          };
          expect(
            Failure.fromJson(invalidJson),
            equals(invalidFailure(invalidJson)),
          );
        },
      );

      test(
        'valid failure json',
        () {
          final type = 'TestFailure';
          final message = 'hey';
          final validJson = {
            'type': type,
            'message': message,
          };
          expect(
            Failure.fromJson(validJson),
            equals(Failure(type, message)),
          );
        },
      );
    },
  );
}
