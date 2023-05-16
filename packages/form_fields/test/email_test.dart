import 'package:form_fields/form_fields.dart' show Email;
import 'package:test/test.dart';

void main() {
  final regex = Email.emailRegex;

  test('Valid email addresses', () {
    expect(regex.hasMatch('john.doe@example.com'), isTrue);
    expect(regex.hasMatch('john123@example.io'), isTrue);
    expect(regex.hasMatch('john-doe@example.com'), isTrue);
    expect(regex.hasMatch('john_doe@example.com'), isTrue);
    expect(regex.hasMatch('john.doe@example.co.jp'), isTrue);
  });

  test('Invalid Email Address', () {
    expect(
      regex.hasMatch('john.doe@.com'),
      isFalse,
      reason: 'missing domain name',
    );

    expect(
      regex.hasMatch('jane.doe+test@example.co.uk'),
      isFalse,
      reason: 'contains plus(+)',
    );

    expect(
      regex.hasMatch('john.doe@example..com'),
      isFalse,
      reason: 'double dot in domain name',
    );

    expect(
      regex.hasMatch('john..doe@example.com'),
      isFalse,
      reason: 'double dot in username',
    );

    expect(
      regex.hasMatch('john.doe@example'),
      isFalse,
      reason: 'missing top-level domain',
    );

    expect(
      regex.hasMatch('john.doe@example.c'),
      isFalse,
      reason: 'invalid top-level domain',
    );

    expect(regex.hasMatch('john.doe@example.123'), isFalse,
        reason: 'top-level domain cannot consist of digits');
  });
}
