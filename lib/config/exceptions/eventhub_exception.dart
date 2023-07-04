class EventHubException implements Exception {
  String cause;
  EventHubException(this.cause);
}
