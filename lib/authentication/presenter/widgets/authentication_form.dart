import 'dart:io';

import 'package:careshare/authentication/cubit/authentication_cubit.dart';
import 'package:careshare/widgets/upload_profile_photo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationForm extends StatelessWidget {
  final AuthenticationState state;

  AuthenticationForm({Key? key, required this.state}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String? errorMessage;
    String? initialNameValue;
    String? initialEmailValue;
    File? photo;
    late String title;
    late String buttonText;
    late String textButtonText;
    switch (state.runtimeType) {
      case AuthenticationRegister:
        errorMessage = (state as AuthenticationRegister).errorMessage;
        title = 'Register';
        buttonText = 'Register';
        textButtonText = 'Already Registered?';
        initialEmailValue = (state as AuthenticationRegister).initialEmailValue;
        initialNameValue = (state as AuthenticationRegister).initialNameValue;
        break;
      case AuthenticationLogin:
        errorMessage = (state as AuthenticationLogin).errorMessage;
        title = 'Login';
        buttonText = 'Login';
        textButtonText = 'Need to Register?';
        initialEmailValue = (state as AuthenticationLogin).initialEmailValue;
        break;
      default:
        initialEmailValue =
            (state as AuthenticationResetPassword).initialEmailValue;
        title = 'Forgotten Password';
        buttonText = 'Send password reset email';
        textButtonText = 'Sign in';
    }
    if (initialEmailValue != null) {
      emailController.text = initialEmailValue;
    }
    if (initialNameValue != null) {
      nameController.text = initialNameValue;
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (state is AuthenticationRegister)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: UploadProfilePhotoWidget(
                        imagePickFn: (File url) {
                          photo = url;
                        },
                      ),
                    ),
                  // Name field
                  if (state is AuthenticationRegister)
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        label: Text('Name'),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 3) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      label: Text('Email'),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter your Email address';
                      }
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[-a-zA-Z0-9]+\.[a-zA-Z]+")
                          // r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value);
                      if (!emailValid) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  if (state is! AuthenticationResetPassword)
                    TextFormField(
                      maxLines: 1,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        label: Text(
                          'Password',
                        ),
                      ),
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
                      obscureText: true,
                    ),
                  Text(
                    errorMessage ?? '',
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (photo == null && state is AuthenticationRegister) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                const Text('You must upload a profile photo'),
                            backgroundColor: Theme.of(context).errorColor,
                          ),
                        );
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        final authenticationCubit =
                            BlocProvider.of<AuthenticationCubit>(context);
                        switch (state.runtimeType) {
                          case AuthenticationRegister:
                            authenticationCubit.register(
                                context: context,
                                email: emailController.text,
                                password: passwordController.text,
                                name: nameController.text,
                                photo: photo!);
                            break;
                          case AuthenticationLogin:
                            authenticationCubit.login(
                              context: context,
                              email: emailController.text,
                              password: passwordController.text,
                              name: nameController.text,
                            );
                            break;
                          default:
                            authenticationCubit.resetPassword(
                              email: emailController.text,
                            );
                        }
                      }
                    },
                    child: Text(buttonText),
                  ),
                  TextButton(
                    onPressed: () {
                      final authenticationCubit =
                          BlocProvider.of<AuthenticationCubit>(context);
                      if (state is! AuthenticationLogin) {
                        authenticationCubit.switchToLogin(
                            emailAddress: emailController.text);
                      } else {
                        authenticationCubit.switchToRegister(
                            emailAddress: emailController.text);
                      }
                    },
                    child: Text(textButtonText),
                  ),
                  if (state is! AuthenticationResetPassword)
                    TextButton(
                      onPressed: () {
                        final authenticationCubit =
                            BlocProvider.of<AuthenticationCubit>(context);

                        authenticationCubit.sentPasswordReset(
                            emailAddress: emailController.text);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'A password reset link has been sent to ${emailController.text}',
                              ),
                              content: const Text(
                                'Please check your junk folder if it does not arrive quickly.',
                              ),
                            );
                          },
                        );
                      },
                      child: const Text('Forgotten Password?'),
                    ),
                  const SizedBox(height: 150),
                  const Text("CareShare version: 0e.0.10+10")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
