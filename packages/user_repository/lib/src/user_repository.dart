import 'dart:math';

import 'package:domain_models/domain_models.dart';

final class UserRepository {
  const UserRepository();
  Future<void> signIn(
    String email,
    String password,
  ) async {
    // TODO:
    await Future.delayed(const Duration(seconds: 1), () {
      final rnd = Random().nextInt(3);
      print(rnd);
      if (rnd == 1) throw GenericException();
      if (rnd == 2) throw InvalidCredentialException();
    });
  }

  // TODO: signUp
}
