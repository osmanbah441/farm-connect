import 'package:form_fields/form_fields.dart' show Password;
import 'package:test/test.dart';

void main() {
  final regex = Password.passwordRegex;
  test('valid passwords', () {
    expect(regex.hasMatch('Abcdefg1@'), isTrue);
    expect(regex.hasMatch('P@ssword1234'), isTrue);
    expect(regex.hasMatch('Helloworld!1'), isTrue);
    expect(regex.hasMatch('1234567aB!'), isTrue);
  });

  test('invalid password', () {
    expect(
      regex.hasMatch('password'),
      isFalse,
      reason: 'no uppercase, no special character',
    );

    expect(
      regex.hasMatch('PASSWORD'),
      isFalse,
      reason: 'no lowercase, no special character',
    );

    expect(
      regex.hasMatch('Password123'),
      isFalse,
      reason: 'no special character',
    );

    expect(
      regex.hasMatch('password123!'),
      isFalse,
      reason: 'no uppercase',
    );

    expect(
      regex.hasMatch('Password!'),
      isFalse,
      reason: 'no digit',
    );

    expect(
      regex.hasMatch('123456789'),
      isFalse,
      reason: ' no letters, no special character',
    );

    expect(
      regex.hasMatch(r'@#$%^&*!'),
      isFalse,
      reason: 'no letters, no digits',
    );

    expect(
      regex.hasMatch('aB1! '),
      isFalse,
      reason: 'less than 8 characters',
    );

    expect(
      regex.hasMatch('aB1!aB1!aB1!aB1!aB1!aB1!aB1!aB1!'),
      isFalse,
      reason: 'more than 20 characters',
    );
  });
}
