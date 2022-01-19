import 'package:flutter/material.dart';

import 'authentication_controller.dart';

class AuthenticationPage extends StatelessWidget {
  final controller = AuthenticationController();

  AuthenticationPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.register,
      builder: (context, bool register, _) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: SafeArea(
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  if (controller.resetSent)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          'You should receive an email to reset your password. \nPlease check your junk mail if you do not see it.',
                          textAlign: TextAlign.center),
                    ),
                  TextFormField(
                    controller: controller.emailAdressController,
                    decoration: const InputDecoration(
                      label: Text(
                        'E-mail address',
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter your Email address';
                      }
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value);
                      if (!emailValid) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                  if (!controller.forgottenPassword)
                    TextFormField(
                      maxLines: 1,
                      controller: controller.passwordController,
                      decoration: const InputDecoration(
                        label: Text(
                          'Password',
                        ),
                        //  icon: IconButton(
                        // icon: Icon(
                        //     controller.hidePassword
                        //         ? Icons.visibility_off
                        //         : Icons.visibility,
                        //     color: Colors.grey),
                        // onPressed: () {
                        //   controller.toggleShowPassword();
                        // },
                      ),
                      // ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Your password must contain at least 6 characters';
                        }

                        return null;
                      },
                      obscureText: controller.hidePassword,
                    ),
                  if (register && !controller.forgottenPassword)
                    TextFormField(
                      maxLines: 1,
                      decoration: const InputDecoration(
                        label: Text(
                          'Confirm Password',
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null) {
                          return 'Please confirm your password';
                        }
                        if (controller.passwordController.text != value) {
                          return 'Your passwords do not match';
                        }

                        return null;
                      },
                      obscureText: controller.hidePassword,
                      // trailing: IconButton(
                      //   icon: Icon(
                      //       controller.hidePassword
                      //           ? Icons.visibility_off
                      //           : Icons.visibility,
                      //       color: Colors.grey),
                      //   onPressed: () {
                      //     controller.toggleShowPassword();
                      //   },
                      // ),
                    ),
                  ElevatedButton(
                    onPressed: () async {
                      if (controller.forgottenPassword) {
                        controller.sendPasswordReminder();
                      }
                      controller.authenticate(context);
                    },
                    child: Text(controller.forgottenPassword
                        ? 'Send reset password link'
                        : register
                            ? 'Register'
                            : 'Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.register.value = !controller.register.value;
                      if (controller.register.value) {
                        controller.forgottenPassword = false;
                      }
                    },
                    child: Text(
                        register ? 'Already registered?' : 'Need to register?'),
                  ),
                  const Spacer(),
                  if (!register && !controller.forgottenPassword)
                    TextButton(
                      onPressed: () {
                        controller.toggleForgotPassword();
                      },
                      child: const Text(
                        'Forgotten your password? \nTap here to send a reset link to your email address',
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
