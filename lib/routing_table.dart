import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in/sign_in.dart';

abstract final class RoutingTable {
  static GoRouter router() => GoRouter(
        debugLogDiagnostics: true,
        initialLocation: _PathConstant.signInPath,
        routes: [
          GoRoute(
            path: _PathConstant.signInPath,
            builder: (context, state) => SignInScreen(
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
