import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:user_repository/user_repository.dart';

import 'sign_in_cubit.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({
    super.key,
    required this.onForgotPasswordTap,
    required this.onSignInSuccessful,
    required this.onSignUpTap,
    required this.userRepository,
  });

  final VoidCallback onSignInSuccessful;
  final VoidCallback onForgotPasswordTap;
  final VoidCallback onSignUpTap;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: BlocProvider(
            create: (context) => SignInCubit(userRepository),
            child: _SignInForm(
              onForgotPasswordTap: onForgotPasswordTap,
              onSignInSuccessful: onSignInSuccessful,
              onSignUpTap: onSignUpTap,
            ),
          ),
        ),
      );
}

class _SignInForm extends StatefulWidget {
  const _SignInForm({
    required this.onForgotPasswordTap,
    required this.onSignInSuccessful,
    required this.onSignUpTap,
  });

  final VoidCallback onSignInSuccessful;
  final VoidCallback onForgotPasswordTap;
  final VoidCallback onSignUpTap;

  @override
  State<_SignInForm> createState() => __SignInFormState();
}

class __SignInFormState extends State<_SignInForm> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SignInCubit>();

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
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      listenWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus,
      listener: (context, state) {
        if (state.submissionStatus.isSuccessful) {
          widget.onSignInSuccessful();
          return;
        }
        if (state.submissionStatus.hasError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text(state.submissionStatus.isInvalidCredentialError
                    ? 'invalid credential, email/password not found'
                    : 'no internet connection')));
        }
      },
      builder: (context, state) {
        final cubit = context.read<SignInCubit>();
        final emailError = state.email.error?.text;
        final passwordError = state.password.error?.text;

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

        final submitButton = state.submissionStatus.isInProgress
            ? ExpandedElevatedButton.inProgress('Loading')
            : ExpandedElevatedButton(
                label: 'Log In',
                onTap: cubit.onSubmit,
              );

        return Column(
          children: [
            Text('Farm connect'),
            Text('Log In'),
            emailTextField,
            passwordTextField,
            submitButton,
            TextButton(
              onPressed: widget.onForgotPasswordTap,
              child: Text('Forgot Password?'),
            ),
            Text("You don't have an account?"),
            TextButton(
              onPressed: widget.onSignUpTap,
              child: Text('Sign up'),
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
        return ''; // only required when registering user.
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
