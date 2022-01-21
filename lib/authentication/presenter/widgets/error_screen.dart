import 'package:careshare/authentication/cubit/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Oh dear. \n$error',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      final authenticationCubit =
                          BlocProvider.of<AuthenticationCubit>(context);
                      authenticationCubit.switchToLogin();
                    },
                    child: const Text('Sign in')),
                ElevatedButton(
                    onPressed: () {
                      final authenticationCubit =
                          BlocProvider.of<AuthenticationCubit>(context);
                      authenticationCubit.switchToRegister();
                    },
                    child: const Text('Register')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
