mixin ChatItemTypeGetter {
  bool get isAnswer;

  T getterType<T>({
    required T question,
    required T answer,
  }) =>
      isAnswer ? answer : question;
}
