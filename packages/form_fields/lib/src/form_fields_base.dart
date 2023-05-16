// Inspiration for the formz package 0.4.0. check it out for doc

/// Check the form status.
enum FormSubmissionStatus {
  initial,
  inProgress,
  successful,
  error;

  bool get isInProgress => this == FormSubmissionStatus.inProgress;

  bool get isSuccessful => this == FormSubmissionStatus.successful;

  bool get hasError => this == FormSubmissionStatus.error;
}

abstract base class FormInput<T, E> {
  const FormInput._(this.value, this.isUnvalidated);

  const FormInput.unvalidated(T value) : this._(value, true);

  const FormInput.validated(T value) : this._(value, false);

  final T value;

  /// check if not validated yet.
  final bool isUnvalidated;

  E? get error => isUnvalidated ? null : validator(value);

  bool get _isValid => validator(value) == null;

  E? validator(T value);

  @override
  String toString() {
    final str = '(value: $value, isValid: $_isValid, error: $error)';
    return isUnvalidated
        ? 'FormInput.unvalidated $str'
        : 'FormInput.validated $str';
  }

  @override
  int get hashCode => Object.hashAll([value, isUnvalidated]);

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) return false;
    return other is FormInput &&
        other.value == value &&
        other.isUnvalidated == isUnvalidated;
  }
}

abstract final class FormFields {
  static bool validate(List<FormInput> inputs) {
    return inputs.every((value) => value._isValid);
  }
}
