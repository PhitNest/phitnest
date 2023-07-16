import 'package:equatable/equatable.dart';

import 'logger.dart';

void badState(Equatable state, Equatable event) {
  prettyLogger.e('$state:\n\tInvalid event: $event');
}
