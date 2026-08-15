import 'package:flutter/material.dart';

class ApiException {
  final String message;
  final int? statusCode;

  ApiException(this.message, {required this.statusCode});
}

enum MessageType {
  success,
  warning,
  error;

  Color get color {
    switch (this) {
      case .warning:
        return Colors.orange;
      case .success:
        return Colors.green;
      default:
        return Colors.red;
    }
  }
}

class MessageException {
  final String message;
  final MessageType type;

  MessageException({required this.message, required this.type});
}

class ViewState<T> {
  final bool isLoading;
  final T? data;
  final MessageException? exception;

  const ViewState._({required this.isLoading, this.data, this.exception});

  const ViewState.idle() : this._(isLoading: false);

  const ViewState.loading() : this._(isLoading: true);

  const ViewState.success(T? data) : this._(isLoading: false, data: data);

  const ViewState.error(MessageException error)
    : this._(isLoading: false, exception: error);
}
