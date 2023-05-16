import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in/sign_in.dart';
import 'package:user_repository/user_repository.dart';

abstract final class RoutingTable {
  static const userRepository = UserRepository();

  static GoRouter router() => GoRouter(
        debugLogDiagnostics: true,
        initialLocation: _PathConstant.signInPath,
        routes: [
          GoRoute(
            path: _PathConstant.signInPath,
            builder: (context, state) => SignInScreen(
              userRepository: userRepository,
              onForgotPasswordTap: () {
                debugPrint('onForgot password');
              },
              onSignInSuccessful: () {
                debugPrint('onSignInSuccessful');
              },
              onSignUpTap: () {
                debugPrint('onSignUpTap');
              },
            ),
          )
        ],
      );
}

abstract final class _PathConstant {
  static const signInPath = '/sign-in';
}
