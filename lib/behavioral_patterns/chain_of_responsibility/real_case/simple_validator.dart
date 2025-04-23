class SimpleValidator {
  static String? validateTextField(String value) {
    if (value.isEmpty) {
      return 'Field cannot be empty';
    }

    if (value.length < 3) {
      return 'Text must be at least 3 characters';
    }

    if (value.length > 20) {
      return 'Text cannot be longer than 20 characters';
    }

    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Only alphanumeric characters allowed';
    }

    return null;
  }
}
