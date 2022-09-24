import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services/auth_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';
  final http.Client? httpClient;
  const SignUpScreen({this.httpClient, super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService authService = AuthService();
  final _signUpFormKey = GlobalKey<FormState>();

  bool _isObscure = true;
  bool _isUser = true;
  bool _isValidPassword = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usertypeController = TextEditingController();

  @override
  dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() {
    //set default usertype to Customer
    _usertypeController.text = "C";
    // print("email: " +
    //     _emailController.text +
    //     " username: " +
    //     _usernameController.text +
    //     " password: " +
    //     _passwordController.text +
    //     " userType: " +
    //     _usertypeController.text);
    authService.signUpUser(
        context: context,
        email: _emailController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        userType: _usertypeController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text("As",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Form(
              key: _signUpFormKey,
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      _isUser ? Colors.white : Colors.grey[400],
                                  backgroundColor:
                                      _isUser ? Colors.green : Colors.grey[200])
                              .copyWith(
                            elevation: ButtonStyleButton.allOrNull(0.0),
                          ),
                          child: const Text('User'),
                          onPressed: () {
                            _usertypeController.text = "";
                            setState(() {
                              _isUser = true;
                            });
                          }),
                    ),
                    const Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 0,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                                  foregroundColor: !_isUser
                                      ? Colors.white
                                      : Colors.grey[400],
                                  backgroundColor: !_isUser
                                      ? Colors.green
                                      : Colors.grey[200])
                              .copyWith(
                            elevation: ButtonStyleButton.allOrNull(0.0),
                          ),
                          child: const Text('Merchant'),
                          onPressed: () {
                            _usertypeController.text = "M";
                            setState(() {
                              _isUser = false;
                            });
                          }),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 100,
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                          filled: true, labelText: "username"),
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                      }),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 100,
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                          filled: true, labelText: "Email"),
                      validator: ((value) {
                        if (value == null ||
                            value.isEmpty ||
                            !EmailValidator.validate(value)) {
                          return 'Please enter a valid email';
                        }
                      }),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 70,
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: (() {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          }),
                        ),
                      ),
                      validator: (value) {
                        if (!_isValidPassword) {
                          return "Please enter a valid password";
                        }
                        return null;
                      },
                      obscureText: _isObscure,
                    ),
                  ),
                  FlutterPwValidator(
                    controller: _passwordController,
                    minLength: 8,
                    uppercaseCharCount: 1,
                    numericCharCount: 1,
                    specialCharCount: 1,
                    width: 350,
                    height: 150,
                    onSuccess: () {
                      setState(() {
                        _isValidPassword = true;
                      });
                    },
                    onFail: () {
                      setState(() {
                        _isValidPassword = false;
                      });
                    },
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ).copyWith(
                          elevation: ButtonStyleButton.allOrNull(0.0),
                        ),
                        child: const Text('Sign Up'),
                        onPressed: () {
                          if (_signUpFormKey.currentState!.validate()) {
                            signUpUser();
                          }
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
