import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

const String dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
const String datePattern1 = 'MMM d, yyyy';
const String datePattern2 = 'MMM. d, yyyy';

extension ObjectExt<T> on T {
  R let<R>(R Function(T that) op) => op(this);
}

extension StringExt on String {
  String get to256 {
    final bytes = utf8.encode(this);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  String get parseDateTimePattern1 {
    final DateTime inputDate =
    DateTime.parse(DateFormat(dateFormat).parse(this).toString());

    return DateFormat(datePattern1).format(inputDate);
  }

  String get parseDateTimePattern2 {
    final DateTime inputDate =
    DateTime.parse(DateFormat(dateFormat).parse(this).toString());

    return DateFormat(datePattern2).format(inputDate);
  }
}

extension CubitExt on Cubit {
  Future<T> run<T>(Future<T> future) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await future;
      return result;
    } on DioError catch (e) {
      emit(state.copyWith(isLoading: false));
      return Future.error(e);
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      return Future.error(e);
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
