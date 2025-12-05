// data/models/result.dart
class ReturnResult {
  final bool state;
  final String message;
  final dynamic data;

  ReturnResult({
    required this.state,
    required this.message,
    this.data,
  });
}