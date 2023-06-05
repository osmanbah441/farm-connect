import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_list/product_list.dart';
import 'package:sign_in/sign_in.dart';
import 'package:sign_up/sign_up.dart';
import 'package:user_repository/user_repository.dart';

abstract final class RoutingTable {
  static const userRepository = UserRepository();

  static GoRouter router() => GoRouter(
        debugLogDiagnostics: true,
        initialLocation: _PathConstant.productListPath,
        routes: [
          _signInRoute,
          _signUpRoute,
          _productListRoute,
        ],
      );

  static get _signInRoute => GoRoute(
        path: _PathConstant.signInPath,
        builder: (context, state) => SignInScreen(
          userRepository: userRepository,
          onForgotPasswordTap: () {
            debugPrint('onForgot password');
          },
          onSignInSuccessful: () {
            debugPrint('onSignInSuccessful');
          },
          onSignUpTap: () => context.go(_PathConstant.signUpPath),
        ),
      );

  static get _signUpRoute => GoRoute(
        path: _PathConstant.signUpPath,
        builder: (context, state) => SignUpScreen(
          userRepository: userRepository,
          onSignInTap: () => context.go(_PathConstant.signInPath),
          onSignUpSuccessful: () {
            debugPrint('sign up success full');
          },
        ),
      );

  static get _productListRoute => GoRoute(
        path: _PathConstant.productListPath,
        builder: (context, state) => const ProductListScreen(),
      );
}

abstract final class _PathConstant {
  static const signInPath = '/sign-in';
  static const signUpPath = '/sign-up';
  static const productListPath = '/product-list';
}
