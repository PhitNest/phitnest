class StateException extends StateError {
  StateException(dynamic state, dynamic event)
      : super('Invalid state: $state received in $event');
}
