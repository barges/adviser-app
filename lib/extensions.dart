import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension ObjectExt<T> on T {
  R let<R>(R Function(T that) op) => op(this);
}

extension StringExt on String {
  String get to256 {
    final bytes = utf8.encode(this);
    final hash = sha256.convert(bytes);
    return hash.toString();
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
