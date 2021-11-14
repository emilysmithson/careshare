import 'package:flutter/material.dart';

import '../../widgets/custom_form_field.dart';
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
          appBar: AppBar(
            title: const Text('Register'),
          ),
          body: SafeArea(
            child: Center(
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    CustomFormField(
                      controller: controller.emailAdressController,
                      label: 'E-mail address',
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
                      CustomFormField(
                        controller: controller.passwordController,
                        label: 'Password',
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
                        trailing: IconButton(
                          icon: Icon(
                              controller.hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey),
                          onPressed: () {
                            controller.toggleShowPassword();
                          },
                        ),
                      ),
                    if (register && !controller.forgottenPassword)
                      CustomFormField(
                          label: 'Confirm password',
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
                          trailing: IconButton(
                            icon: Icon(
                                controller.hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey),
                            onPressed: () {
                              controller.toggleShowPassword();
                            },
                          )),
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
                      },
                      child: Text(register
                          ? 'Already registered?'
                          : 'Need to register?'),
                    ),
                    const Spacer(),
                    if (!register)
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
          ),
        );
      },
    );
  }
}
