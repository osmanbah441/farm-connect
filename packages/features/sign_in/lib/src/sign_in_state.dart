part of 'sign_in_cubit.dart';

final class SignInState extends Equatable {
  const SignInState({
    this.email = const Email.unvalidated(),
    this.password = const Password.unvalidated(),
    this.submissionStatus = FormSubmissionStatus.initial,
  });

  final Email email;
  final Password password;
  final FormSubmissionStatus submissionStatus;

  SignInState copyWith({
    Email? email,
    Password? password,
    FormSubmissionStatus? submissionStatus,
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
