import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this.userRepository) : super(const SignInState());

  final UserRepository userRepository;

  void onEmailChanged(String newValue) {
    final shouldValidate = !state.email.isUnvalidated;
    final newEmail = shouldValidate
        ? Email.validated(newValue)
        : Email.unvalidated(newValue);

    final newState = state.copyWith(email: newEmail);
    emit(newState);
  }

  void onEmailUnfocused() {
    final emailValue = Email.validated(state.email.value);
    final newState = state.copyWith(email: emailValue);
    emit(newState);
  }

  void onPasswordChanged(String newValue) {
    final shouldValidate = !state.password.isUnvalidated;
    final newPassword = shouldValidate
        ? Password.validated(newValue)
        : Password.unvalidated(newValue);

    final newState = state.copyWith(password: newPassword);
    emit(newState);
  }

  void onPasswordUnfocused() {
    final passwordValue = state.password.value;
    final newPassword = Password.validated(passwordValue);

    final newState = state.copyWith(password: newPassword);
    emit(newState);
  }

  void onSubmit() {
    final email = Email.validated(state.email.value);
    final password = Password.validated(state.password.value);

    final isFormValid = FormFields.validate([email, password]);
    if (isFormValid) {
      emit(state.copyWith(submissionStatus: SubmissionStatus.inProgress));
      _signIn(email.value, password.value);
    } else {
      emit(state.copyWith(email: email, password: password));
    }
  }

  void _signIn(String email, String password) async {
    try {
      await userRepository.signIn(email, password);
      emit(state.copyWith(submissionStatus: SubmissionStatus.successful));
    } catch (error) {
      emit(state.copyWith(
        submissionStatus: error is InvalidCredentialException
            ? SubmissionStatus.invalidCredentialError
            : SubmissionStatus.genericError,
      ));
    }
  }
}
