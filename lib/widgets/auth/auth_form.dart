import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  final bool isLoading;

  const AuthForm(this.submitFn, this.isLoading, {Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateEmail(String email) {
    return EmailValidator.validate(email);
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    widget.submitFn(
      _authData['email']!.trim(),
      _authData['password']!.trim(),
      _authMode == AuthMode.login,
      context,
    );
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: const ValueKey('email'),
                    autocorrect: false,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.none,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email can\'t be empty!';
                      }
                      if (!_validateEmail(value)) {
                        return 'Email is not valid!';
                      }
                      return null;
                    },
                    onSaved: (value) => _authData['email'] = value!,
                  ),
                  TextFormField(
                    key: const ValueKey('password'),
                    controller: _passwordController,
                    textInputAction: _authMode == AuthMode.login
                        ? TextInputAction.done
                        : TextInputAction.next,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password can\'t be empty!';
                      }
                      if (value.length < 6) {
                        return 'Your password must be at least 6 characters long!';
                      }
                      return null;
                    },
                    onSaved: (value) => _authData['password'] = value!,
                  ),
                  if (_authMode == AuthMode.signup)
                    TextFormField(
                      key: const ValueKey('passConfirm'),
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm password',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      validator: _authMode == AuthMode.signup
                          ? (value) {
                              if (value! != _passwordController.text) {
                                return 'Passwords don\'t match!';
                              }
                              return null;
                            }
                          : null,
                    ),
                  const SizedBox(height: 12.0),
                  if (widget.isLoading)
                    CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _saveForm,
                      child: Text(
                        _authMode == AuthMode.login ? 'Log In' : 'Sign Up',
                      ),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: _switchAuthMode,
                      child: Text(
                        _authMode == AuthMode.login
                            ? 'Sign up instead'
                            : 'Log in instead',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
