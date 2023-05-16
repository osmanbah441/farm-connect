part of 'sign_in_cubit.dart';

final class SignInState extends Equatable {
  const SignInState({
    this.email = const Email.unvalidated(),
    this.password = const Password.unvalidated(),
    this.submissionStatus = SubmissionStatus.initial,
  });

  final Email email;
  final Password password;
  final SubmissionStatus submissionStatus;

  SignInState copyWith({
    Email? email,
    Password? password,
    SubmissionStatus? submissionStatus,
  }) =>
      SignInState(
        email: email ?? this.email,
        password: password ?? this.password,
        submissionStatus: submissionStatus ?? this.submissionStatus,
      );

  @override
  List<Object?> get props => [
        email,
        password,
        submissionStatus,
      ];
}

enum SubmissionStatus {
  initial,
  inProgress,
  successful,

  // all errors
  invalidCredentialError,

  // when not connected to internet.
  genericError,
  ;

  bool get isInProgress => this == SubmissionStatus.inProgress;

  bool get isSuccessful => this == SubmissionStatus.successful;

  bool get isInvalidCredentialError =>
      this == SubmissionStatus.invalidCredentialError;

  bool get hasError =>
      isInvalidCredentialError || this == SubmissionStatus.genericError;
}
