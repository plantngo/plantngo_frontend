import 'package:flutter/material.dart';
import '../../validators/email_validator.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);
  static const routeName = '/forget';

  @override
  ForgetPasswordScreenState createState() => ForgetPasswordScreenState();
}

class ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  String? _email;
  bool _emailSent = false;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Reset Password",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Form(
          key: _formKey,
          // autovalidateMode: AutovalidateMode.always,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(
                  height: 200,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  validator: ((value) => validateEmail(value)),
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Your email address',
                    labelText: 'Email',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ).copyWith(
                      elevation: ButtonStyleButton.allOrNull(0.0),
                    ),
                    child: const Text('Send Email'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _emailSent = true;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: _emailSent
                      ? const Text(
                          "Email Sent",
                          style: TextStyle(fontSize: 16),
                        )
                      : null,
                )
              ],
            ),
          )),
    );
  }
}