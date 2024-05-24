import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class PasswordGenerator extends StatefulWidget {
  const PasswordGenerator({super.key});

  @override
  State<PasswordGenerator> createState() => _PasswordGeneratorState();
}

class _PasswordGeneratorState extends State<PasswordGenerator> {
  final _formKey = GlobalKey<FormBuilderState>();
  String _password = '';
  bool _isPassGenerated = false;
  bool _lowerCase = true;
  bool _upperCase = false;
  bool _numbers = false;
  bool _symbols = false;

  String generatePasswordString(int passwordLength) {
    String charactersList = '';
    const upperCaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowerCaseChars = 'abcdefghijklmnopqrstuvwxyz';
    const digitChars = '0123456789';
    const specialChars = '!@#%^&*()_+-=[]{}|;:",./<>?';

    if (_upperCase) charactersList += upperCaseChars;
    if (_lowerCase) charactersList += lowerCaseChars;
    if (_numbers) charactersList += digitChars;
    if (_symbols) charactersList += specialChars;

    if (charactersList.isEmpty) {
      return '';
    }

    String passwordResult = createPassword(charactersList, passwordLength);

    setState(() {
      _password = passwordResult;
      _isPassGenerated = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password has been generated')),
    );

    return passwordResult;
  }

  String createPassword(String characters, int passwordLength) {
    final rand = Random();
    return List.generate(passwordLength, (index) => characters[rand.nextInt(characters.length)]).join();
  }

  void resetPasswordState() {
    setState(() {
      _password = '';
      _isPassGenerated = false;
      _lowerCase = true;
      _upperCase = false;
      _numbers = false;
      _symbols = false;
    });
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password copied')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Generator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'passwordLength',
                  decoration: const InputDecoration(
                    labelText: 'Password Length',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                    FormBuilderValidators.min(10),
                    FormBuilderValidators.max(200),
                  ]),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _lowerCase,
                      onChanged: (bool? value) {
                        setState(() {
                          _lowerCase = value!;
                        });
                      },
                    ),
                    const Text('Include Lowercase'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _upperCase,
                      onChanged: (bool? value) {
                        setState(() {
                          _upperCase = value!;
                        });
                      },
                    ),
                    const Text('Include Uppercase'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _numbers,
                      onChanged: (bool? value) {
                        setState(() {
                          _numbers = value!;
                        });
                      },
                    ),
                    const Text('Include Numbers'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _symbols,
                      onChanged: (bool? value) {
                        setState(() {
                          _symbols = value!;
                        });
                      },
                    ),
                    const Text('Include Symbols'),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          int passwordLength = int.parse(_formKey.currentState!.fields['passwordLength']!.value);
                          generatePasswordString(passwordLength);
                        }
                      },
                      child: const Text('Generate Password'),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        resetPasswordState();
                        _formKey.currentState?.reset();
                      },
                      child: const Text('Reset Password'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                if (_isPassGenerated) ...[
                  Text(_password),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      copyToClipboard(_password);
                    },
                    child: const Text('Copy to Clipboard'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
