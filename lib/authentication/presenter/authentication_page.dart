import 'package:careshare/authentication/cubit/authentication_cubit.dart';
import 'package:careshare/authentication/presenter/widgets/authentication_form.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        if (state == AuthenticationLoading()) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is AuthenticationRegister ||
            state is AuthenticationLogin ||
            state is AuthenticationResetPassword) {
          return AuthenticationForm(state: state);
        }

        return Text(state.toString());
      },
    );
  }
}
