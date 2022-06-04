import 'package:careshare/authentication/cubit/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AuthenticationForm extends StatefulWidget {
  final AuthenticationState state;

  const AuthenticationForm({Key? key, required this.state}) : super(key: key);

  @override
  State<AuthenticationForm> createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle.isEmpty ? 'Not set' : subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? errorMessage;
    String? initialNameValue;
    String? initialEmailValue;
    // File? photo;
    late String title;
    late String buttonText;
    late String textButtonText;
    switch (widget.state.runtimeType) {
      case AuthenticationRegister:
        errorMessage = (widget.state as AuthenticationRegister).errorMessage;
        title = 'Create a new Careshare account';
        buttonText = 'Create account';
        textButtonText = 'Already Registered?';
        initialEmailValue = (widget.state as AuthenticationRegister).initialEmailValue;
        initialNameValue = (widget.state as AuthenticationRegister).initialNameValue;
        break;
      case AuthenticationLogin:
        errorMessage = (widget.state as AuthenticationLogin).errorMessage;
        title = 'Careshare';
        buttonText = 'Log in';
        textButtonText = 'Create new account';
        initialEmailValue = (widget.state as AuthenticationLogin).initialEmailValue;
        break;
      default:
        initialEmailValue = (widget.state as AuthenticationResetPassword).initialEmailValue;
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
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Image.asset('images/CareShareLogo50.jpg'),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // if (widget.state is AuthenticationRegister)
                  //   Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: UploadProfilePhotoWidget(
                  //       imagePickFn: (File url) {
                  //         photo = url;
                  //       },
                  //     ),
                  //   ),
                  // Name field
                  // if (widget.state is AuthenticationRegister)
                  //   TextFormField(
                  //     controller: nameController,
                  //     decoration: const InputDecoration(
                  //       label: Text('Name'),
                  //     ),
                  //     validator: (value) {
                  //       if (value == null || value.length < 3) {
                  //         return 'Please enter your name';
                  //       }
                  //       return null;
                  //     },
                  //     keyboardType: TextInputType.name,
                  //   ),
                  const SizedBox(height: 46),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      label: Text('Email'),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter your Email address';
                      }
                      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[-a-zA-Z0-9]+\.[a-zA-Z]+")
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
                  if (widget.state is! AuthenticationResetPassword)
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

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: TextButton(
                            style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.blue,
                                textStyle: const TextStyle(fontSize: 20)),
                            onPressed: () {
                              // if (photo == null && widget.state is AuthenticationRegister) {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //       content: const Text('You must upload a profile photo'),
                              //       backgroundColor: Theme.of(context).errorColor,
                              //     ),
                              //   );
                              //   return;
                              // }
                              if (_formKey.currentState!.validate()) {
                                final authenticationCubit = BlocProvider.of<AuthenticationCubit>(context);
                                switch (widget.state.runtimeType) {
                                  case AuthenticationRegister:
                                    authenticationCubit.register(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name: nameController.text,
                                      // photo: photo!
                                    );
                                    break;
                                  case AuthenticationLogin:
                                    authenticationCubit.login(
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
                        ),
                      ),
                    ],
                  ),
                  if (widget.state is! AuthenticationResetPassword)
                    TextButton(
                      onPressed: () {
                        final authenticationCubit = BlocProvider.of<AuthenticationCubit>(context);

                        authenticationCubit.sentPasswordReset(emailAddress: emailController.text);
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}",
                        style: new TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(" or "),
                      Text(
                        "\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}\u{00A0}",
                        style: new TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.lightBlueAccent,
                        textStyle: const TextStyle(fontSize: 18)),

                    onPressed: () {
                      final authenticationCubit = BlocProvider.of<AuthenticationCubit>(context);
                      if (widget.state is! AuthenticationLogin) {
                        authenticationCubit.switchToLogin(emailAddress: emailController.text);
                      } else {
                        authenticationCubit.switchToRegister(emailAddress: emailController.text);
                      }
                    },
                    child: Text(textButtonText),
                  ),

                  const SizedBox(height: 150),
                  Text("CareShare version: ${_packageInfo.version}+${_packageInfo.buildNumber}")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
