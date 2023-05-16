part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.name = const Username.unvalidated(),
    this.email = const Email.unvalidated(),
    this.password = const Password.unvalidated(),
    this.comfirmationPassword = const ComfirmationPassword.unvalidated(),
    this.submissionStatus = SubmissionStatus.initial,
  });

  final Username name;
  final Email email;
  final Password password;
  final ComfirmationPassword comfirmationPassword;
  final SubmissionStatus submissionStatus;

  SignUpState copyWith({
    Username? name,
    Email? email,
    Password? password,
    ComfirmationPassword? comfirmationPassword,
    SubmissionStatus? submissionStatus,
  }) =>
      SignUpState(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        comfirmationPassword: comfirmationPassword ?? this.comfirmationPassword,
        submissionStatus: submissionStatus ?? this.submissionStatus,
      );

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        comfirmationPassword,
        submissionStatus,
      ];
}

enum SubmissionStatus {
  initial,
  inProgress,
  successful,

  error,
  ;

  // getters
  bool get isInProgress => this == SubmissionStatus.inProgress;

  bool get isSuccessful => this == SubmissionStatus.successful;

  bool get isGenericError => this == SubmissionStatus.error;
}
