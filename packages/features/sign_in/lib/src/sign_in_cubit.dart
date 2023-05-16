import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(const SignInState());

  // TODO: add user repostory

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
      emit(state.copyWith(submissionStatus: FormSubmissionStatus.inProgress));
      _signIn();
    } else {
      emit(state.copyWith(email: email, password: password));
    }
  }

  void _signIn() async {
    // TODO: call api and handle error
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(submissionStatus: FormSubmissionStatus.initial));
  }
}
