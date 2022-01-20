import 'package:careshare/authentication/cubit/authentication_cubit.dart';
import 'package:careshare/profile/cubit/profile_cubit.dart';
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
    late String title;
    late String buttonText;
    late String textButtonText;
    switch (state.runtimeType) {
      case AuthenticationRegister:
        title = 'Register';
        buttonText = 'Submit';
        textButtonText = 'Already Registered?';
        break;
      case AuthenticationLogin:
        title = 'Login';
        buttonText = 'Submit';
        textButtonText = 'Need to Register?';
        break;
      default:
        title = 'Forgotten Password';
        buttonText = 'Send password reset email';
        textButtonText = 'Sign in';
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (state is AuthenticationRegister)
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      label: Text('Name'),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter your name';
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.name,
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    label: Text('E-mail Address'),
                  ),
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: true,
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final authenticationCubit =
                          BlocProvider.of<AuthenticationCubit>(context);
                      switch (state.runtimeType) {
                        case AuthenticationRegister:
                          authenticationCubit.register(
                            profileCubit:
                                BlocProvider.of<ProfileCubit>(context),
                            email: emailController.text,
                            password: passwordController.text,
                            name: nameController.text,
                          );
                          break;
                        case AuthenticationLogin:
                          authenticationCubit.signIn(
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
                      authenticationCubit.switchToLogin();
                    } else {
                      authenticationCubit.switchToRegister();
                    }
                  },
                  child: Text(textButtonText),
                ),
                if (state is! AuthenticationResetPassword)
                  TextButton(
                    onPressed: () {
                      final authenticationCubit =
                          BlocProvider.of<AuthenticationCubit>(context);

                      authenticationCubit.switchToResetPassword();
                    },
                    child: const Text('Forgotten Password?'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
