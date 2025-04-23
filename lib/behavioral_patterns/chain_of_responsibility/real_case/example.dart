import 'package:design_patterns/behavioral_patterns/chain_of_responsibility/real_case/chain_validators.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ValidationFormExample(),
    ),
  );
}

class ValidationFormExample extends StatefulWidget {
  const ValidationFormExample({super.key});

  @override
  State<ValidationFormExample> createState() => _ValidationFormExampleState();
}

class _ValidationFormExampleState extends State<ValidationFormExample> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  late final ValidationHandler _validator;

  @override
  void initState() {
    super.initState();

    _validator =
        LengthValidator(min: 3, max: 20).setNext(EmptyValidator()).setNext(AlphanumericValidator());
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validation Form Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                ),
                validator: (value) => _validator.handle(value ?? ''),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
                obscureText: true,
                validator: (value) => _validator.handle(value ?? ''),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Form is valid!')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
