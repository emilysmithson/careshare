import 'package:careshare/authentication/cubit/authentication_cubit.dart';
import 'package:careshare/authentication/presenter/widgets/authentication_form.dart';
import 'package:careshare/core/presentation/loading_page_template.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationPage extends StatelessWidget {
  static const String routeName = "/";
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthenticationCubit>(context).checkAuthentication();
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationLoading) {
          return const LoadingPageTemplate(loadingMessage: 'Authenticating...');
        }
        if (state is AuthenticationRegister ||
            state is AuthenticationLogin ||
            state is AuthenticationResetPassword) {
          return AuthenticationForm(state: state);
        }

        if (state is AuthenticationLoaded) {
          return const LoadingPageTemplate(
              loadingMessage: 'Authenticated Loaded');
          //   WidgetsBinding.instance.addPostFrameCallback(
          //     (_) => Navigator.pushReplacementNamed(context, HomePage.routeName),
          //   );

          //   return const Scaffold();

        }
        if (state is AuthenticationRegistered) {
          return const LoadingPageTemplate(
              loadingMessage: 'Authenticated Registered');
          //   WidgetsBinding.instance.addPostFrameCallback(
          //     (_) => Navigator.pushReplacementNamed(context, HomePage.routeName),
          //   );

          //   return const Scaffold();

        }

        return Scaffold(
          body: Center(
            child: Text(
              state.toString(),
            ),
          ),
        );
      },
    );
  }
}
