import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/exception.dart';
import '../providers/auth.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final Map<String, String> _authData = {'mail': '', 'password': ''};
  bool _signUp = false;
  bool _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (contex) => AlertDialog(
              title: const Text('Error ocured'),
              content: Text(message),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok'))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_signUp) {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['mail']!, _authData['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .logIn(_authData['mail']!, _authData['password']!);
      }
    } on HttpException catch (error) {
      var message = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        message = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        message = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        message = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        message = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        message = 'Invalid password.';
      }
      _showErrorDialog(message);
    } catch (error) {
      _showErrorDialog('Couldn\'t authenticate you.Please try later.');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Give valid mail';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['mail'] = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                textInputAction: TextInputAction.done,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.length <= 5) {
                    return 'Give valid password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value!;
                },
              ),
              if (_signUp)
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Repeat Password'),
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  onPressed: () {
                    _submit();
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.purple[200])),
                  child: _isLoading
                      ? const SizedBox(
                          height: 25,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                      : Text(_signUp ? 'Sign up' : 'Log in'),
                ),
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _signUp = !_signUp;
                    });
                  },
                  child: Text(_signUp ? 'Log in' : 'Sign up')),
            ],
          ),
        ),
      ),
    );
  }
}
