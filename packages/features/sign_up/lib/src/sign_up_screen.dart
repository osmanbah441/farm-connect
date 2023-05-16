import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:sign_up/src/sign_up_cubit.dart';
import 'package:user_repository/user_repository.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({
    super.key,
    required this.userRepository,
    required this.onSignUpSuccessful,
    required this.onSignInTap,
  });

  final UserRepository userRepository;
  final VoidCallback onSignUpSuccessful;
  final VoidCallback onSignInTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocProvider(
        create: (context) => SignUpCubit(userRepository),
        child: _SignUpForm(
          onSignInTap: onSignInTap,
          onSignUpSuccessful: onSignUpSuccessful,
        ),
      )),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  const _SignUpForm({
    required this.onSignUpSuccessful,
    required this.onSignInTap,
  });

  final VoidCallback onSignUpSuccessful;
  final VoidCallback onSignInTap;

  @override
  State<_SignUpForm> createState() => __SignUpFormState();
}

class __SignUpFormState extends State<_SignUpForm> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _comfirmationPasswordFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SignUpCubit>();

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        cubit.onEmailUnfocused();
      }
    });

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        cubit.onPasswordUnfocused();
      }
    });

    _comfirmationPasswordFocusNode.addListener(() {
      if (!_comfirmationPasswordFocusNode.hasFocus) {
        cubit.onComfirmationPasswordUnfocused();
      }
    });

    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        cubit.onNameUnfocused();
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _comfirmationPasswordFocusNode.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listenWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus,
      listener: (context, state) {
        if (state.submissionStatus.isSuccessful) {
          widget.onSignUpSuccessful();
          return;
        }
        if (state.submissionStatus.isGenericError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const GenericErrorSnackBar());
        }
      },
      builder: (context, state) {
        final cubit = context.read<SignUpCubit>();
        final emailError = state.email.error?.text;
        final passwordError = state.password.error?.text;
        final nameError = state.name.error?.text;
        final comfirmPasswordError = state.comfirmationPassword.error?.text;

        final nameTextField = TextField(
          focusNode: _nameFocusNode,
          onChanged: cubit.onNameChanged,
          autocorrect: false,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          autofocus: false,
          decoration: InputDecoration(
            labelText: 'Name',
            hintText: 'Enter your name',
            errorText: nameError,
          ),
        );

        final emailTextField = TextField(
          focusNode: _emailFocusNode,
          onChanged: cubit.onEmailChanged,
          autocorrect: false,
          autofocus: false,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'osman@gmail.com',
            errorText: emailError,
          ),
        );

        final passwordTextField = TextField(
          focusNode: _passwordFocusNode,
          onChanged: cubit.onPasswordChanged,
          autocorrect: false,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
          autofocus: false,
          decoration: InputDecoration(
              labelText: 'Passoword',
              hintText: 'Enter your password',
              errorText: passwordError),
        );

        final comfirmationPasswordTextField = TextField(
          focusNode: _comfirmationPasswordFocusNode,
          onChanged: cubit.onComfirmationPasswordChanged,
          autocorrect: false,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
          autofocus: false,
          decoration: InputDecoration(
              labelText: 'Comfirmation Password',
              hintText: 'comfirm your pasword',
              errorText: comfirmPasswordError),
        );

        final submitButton = state.submissionStatus.isInProgress
            ? ExpandedElevatedButton.inProgress('Loading')
            : ExpandedElevatedButton(
                label: 'Create',
                onTap: cubit.onSubmit,
              );
        return Column(
          children: [
            const Text('Create Account'),
            nameTextField,
            emailTextField,
            passwordTextField,
            comfirmationPasswordTextField,
            submitButton,
            const Text('Already have an account?'),
            TextButton(
              onPressed: widget.onSignInTap,
              child: const Text('Log in'),
            ),
          ],
        );
      },
    );
  }
}

// TODO: replace with with i18n and l10n
extension on EmailValidationError {
  String get text {
    switch (this) {
      case EmailValidationError.empty:
        return 'this field cannot be empty';
      case EmailValidationError.invalid:
        return 'please enter a valid email address.';
      case EmailValidationError.alreadyRegistered:
        return 'email already exist';
    }
  }
}

// TODO: replace with with i18n and l10n
extension on PasswordValidationError {
  String get text {
    switch (this) {
      case PasswordValidationError.empty:
        return 'this field cannot be empty';
      case PasswordValidationError.short:
        return 'must be at least 8 characters long';
      case PasswordValidationError.invalid:
        return 'must contain a combination uppercase and lowercase letters, numbers, and special characters (!@#\$&*~).';
    }
  }
}

// TODO: replace with with i18n and l10n
extension on ComfirmationPasswordValidationError {
  String get text {
    switch (this) {
      case ComfirmationPasswordValidationError.empty:
        return 'this field cannot be empty';

      case ComfirmationPasswordValidationError.notMatch:
        return 'password not match';
    }
  }
}

// TODO: replace with with i18n and l10n
extension on UsernameValidationError {
  String get text {
    switch (this) {
      case UsernameValidationError.empty:
        return 'this field cannot be empty';
      case UsernameValidationError.length:
        return 'lenght';
      case UsernameValidationError.invalid:
        return 'invalid';
    }
  }
}
