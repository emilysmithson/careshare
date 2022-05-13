import 'package:careshare/authentication/cubit/authentication_cubit.dart';
import 'package:careshare/authentication/presenter/widgets/authentication_form.dart';
import 'package:careshare/core/presentation/error_page_template.dart';
import 'package:careshare/core/presentation/loading_page_template.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../profile_manager/presenter/fetch_my_profile_page.dart';

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
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => Navigator.pushReplacementNamed(
                context, FetchMyProfilePage.routeName,
                arguments: state.user.uid),
          );

          return Container();
        }
        if (state is AuthenticationRegistered) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => Navigator.pushReplacementNamed(
                    context,
                    FetchMyProfilePage.routeName,
                    arguments: {
                      "id": state.userId,
                      'createProfile': true,
                      'photo': state.photo,
                      'name': state.name,
                      'email': state.emailAddress
                    },
                  ));

          return Container();
        }
        if (state is AuthenticationError) {
          return ErrorPageTemplate(errorMessage: state.message);
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
