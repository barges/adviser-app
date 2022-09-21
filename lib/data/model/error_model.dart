import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class ErrorModel extends Equatable {
  final ErrorType errorType;
  final String? errorValue;

  const ErrorModel({required this.errorType, this.errorValue});

  @override
  List<Object?> get props => [errorType, errorValue];

}

ErrorModel errorMessageAdapter(dynamic error) {
  if (error is DioError) {
    switch (error.type) {
      case DioErrorType.cancel:
        return const ErrorModel(
            errorType: ErrorType.responseError,
            errorValue: "Request was cancelled");
      case DioErrorType.connectTimeout:
        return const ErrorModel(
            errorType: ErrorType.connectingError,
            errorValue: "Check your internet connection");
      case DioErrorType.receiveTimeout:
        return const ErrorModel(
            errorType: ErrorType.connectingError,
            errorValue: "Receive timeout in connection");
      case DioErrorType.response:
        return ErrorModel(
            errorType: ErrorType.responseError,
            errorValue:
            "Received invalid status code: ${error.response!.statusCode}");
      case DioErrorType.sendTimeout:
        return const ErrorModel(
            errorType: ErrorType.connectingError,
            errorValue: "Receive timeout in send request");
      case DioErrorType.other:
        return const ErrorModel(
            errorType: ErrorType.responseError,
            errorValue: "There are some errors..");
    }
  }
  return const ErrorModel(
      errorType: ErrorType.responseError,
      errorValue: "There are some errors..");
}

enum ErrorType { connectingError, responseError }
