import 'dart:async';

import 'package:bloc/bloc.dart';

abstract class BaseCubit<T> extends Cubit<T> {
  BaseCubit(super.initialState);

  final List<StreamSubscription> listeners = [];

  void addListener(StreamSubscription listener) {
    listeners.add(listener);
  }

  @override
  Future<void> close() {
    for (var element in listeners) {
      element.cancel();
    }
    return super.close();
  }
}
