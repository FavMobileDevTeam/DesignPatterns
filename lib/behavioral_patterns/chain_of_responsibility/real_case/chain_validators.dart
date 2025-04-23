abstract class ValidationHandler {
  ValidationHandler? _nextHandler;

  ValidationHandler setNext(ValidationHandler handler) {
    _nextHandler = handler;

    return handler;
  }

  String? handle(String value) {
    final error = validate(value);
    if (error != null) {
      return error;
    }

    if (_nextHandler != null) {
      return _nextHandler!.handle(value);
    }

    return null;
  }

  String? validate(String value);
}

class EmptyValidator extends ValidationHandler {
  @override
  String? validate(String value) {
    if (value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }
}

class LengthValidator extends ValidationHandler {
  final int min;
  final int max;

  LengthValidator({required this.min, required this.max});

  @override
  String? validate(String value) {
    if (value.length < min) {
      return 'Text must be at least $min characters';
    }
    if (value.length > max) {
      return 'Text cannot be longer than $max characters';
    }
    return null;
  }
}

class AlphanumericValidator extends ValidationHandler {
  @override
  String? validate(String value) {
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Only alphanumeric characters allowed';
    }
    return null;
  }
}
