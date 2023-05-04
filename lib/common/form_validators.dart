import 'extensions.dart';

class FormValidators {
  FormValidators._();

  static String? email(String? value) {
    final s = value?.trim();

    if (s.isNullOrBlank()) return 'Required';
    if (!_emRegex.hasMatch(s!)) return 'Invalid email';

    return null;
  }

  static String? password(String? value) {
    final s = value?.trim();

    if (s.isNullOrBlank()) return 'Required';
    if (s!.length < minPassLength) return 'Should $minPassLength characters';

    return null;
  }

  static String? empty(String? value) {
    final s = value?.trim();
    if (s == null || s.isEmpty) return 'Required';
    return null;
  }
}

final _emRegex = RegExp(r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)');
const minPassLength = 5;
