import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this.userRepository) : super(const SignUpState());

  final UserRepository userRepository;
  void onNameChanged(String newValue) {
    final shouldValidate = !state.name.isUnvalidated;
    final newName = shouldValidate
        ? Username.validated(newValue)
        : Username.unvalidated(newValue);

    final newState = state.copyWith(name: newName);
    emit(newState);
  }

  void onNameUnfocused() {
    final nameValue = Username.validated(state.name.value);
    final newState = state.copyWith(name: nameValue);
    emit(newState);
  }

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

  void onComfirmationPasswordChanged(String newValue) {
    final shouldValidate = !state.comfirmationPassword.isUnvalidated;
    final newPassword = shouldValidate
        ? ComfirmationPassword.validated(newValue, state.password)
        : ComfirmationPassword.unvalidated(newValue);

    final newState = state.copyWith(comfirmationPassword: newPassword);
    emit(newState);
  }

  void onComfirmationPasswordUnfocused() {
    final passwordValue = ComfirmationPassword.validated(
        state.comfirmationPassword.value, state.password);
    final newState = state.copyWith(comfirmationPassword: passwordValue);
    emit(newState);
  }

  void onSubmit() {
    final name = Username.validated(state.name.value);
    final email = Email.validated(state.email.value);
    final password = Password.validated(state.password.value);
    final comfirmationPassword = ComfirmationPassword.validated(
      state.comfirmationPassword.value,
      password,
    );

    final isFormValid = FormFields.validate([
      name,
      email,
      password,
      comfirmationPassword,
    ]);

    if (isFormValid) {
      emit(state.copyWith(submissionStatus: SubmissionStatus.inProgress));
      _signUp(name.value, email.value, password.value);
    } else {
      emit(state.copyWith(email: email, password: password));
    }
  }

  void _signUp(String name, String email, String password) async {
    try {
      await userRepository.signUp(name, email, password);
      emit(state.copyWith(submissionStatus: SubmissionStatus.successful));
    } catch (error) {
      final emailExist = error is EmailAlreadyRegisteredException;
      emit(state.copyWith(
        email: emailExist
            ? Email.validated(email, isAlreadyRegistered: true)
            : null,
        submissionStatus:
            emailExist ? SubmissionStatus.initial : SubmissionStatus.error,
      ));
    }
  }
}
