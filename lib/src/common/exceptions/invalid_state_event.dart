/// Exception thrown when an invalid state/event occurs.
class InvalidStateEventException implements Exception {
  final String message;

  const InvalidStateEventException(dynamic state, dynamic event)
      : message = 'Invalid state/event:\n\tstate: $state\n\tevent: $event';

  @override
  String toString() => message;
}
