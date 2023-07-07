import 'package:eventhub/utils/util.dart';

class StandardError {
  String? timestamp;
  int? status;
  String? error;
  String? message;
  String? path;

  StandardError({
    this.timestamp,
    this.status,
    this.error,
    this.message,
    this.path,
  });

  factory StandardError.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return StandardError(
        timestamp: jsons['timestamp'],
        status: jsons['status'],
        error: jsons['error'],
        message: jsons['message'],
        path: jsons['path']);
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'status': status,
        'error': error,
        'message': message,
        'path': path
      };
}
