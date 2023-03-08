class InvalidStateEventException implements Exception {
  final String message;

  InvalidStateEventException(dynamic state, dynamic event)
      : message = 'Invalid state/event:\n\tstate: $state\n\tevent: $event';

  @override
  String toString() => message;
}
