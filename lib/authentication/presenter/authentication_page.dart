import 'package:careshare/authentication/cubit/authentication_cubit.dart';
import 'package:careshare/authentication/presenter/widgets/authentication_form.dart';
import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/caregroup_manager/presenter/caregroup_manager.dart';
import 'package:careshare/category_manager/cubit/category_cubit.dart';
import 'package:careshare/notifications/presenter/cubit/notifications_cubit.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationPage extends StatelessWidget {
  static const String routeName = "/";
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthenticationCubit>(context).checkAuthentication(
      profileCubit: BlocProvider.of<ProfileCubit>(context),
      caregroupCubit: BlocProvider.of<CaregroupCubit>(context),
      taskCubit: BlocProvider.of<TaskCubit>(context),
      categoriesCubit: BlocProvider.of<CategoriesCubit>(context),
      notificationsCubit: BlocProvider.of<NotificationsCubit>(context),
    );
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is AuthenticationRegister ||
            state is AuthenticationLogin ||
            state is AuthenticationResetPassword) {
          return AuthenticationForm(state: state);
        }

        if (state is AuthenticationLoaded) {
            WidgetsBinding.instance?.addPostFrameCallback(
              (_) => Navigator.pushReplacementNamed(
                  context, CaregroupsManager.routeName),
            );

          // if (BlocProvider.of<CaregroupCubit>(context).caregroupList.length > 1) {
          //
          //   WidgetsBinding.instance?.addPostFrameCallback(
          //     (_) => Navigator.pushReplacementNamed(
          //         context, CaregroupsManager.routeName),
          //   );
          // }
          // else {
          //   WidgetsBinding.instance?.addPostFrameCallback(
          //         (_) => Navigator.pushReplacementNamed(
          //         context, TaskManagerView.routeName),
          //   );
          // }
          return const Scaffold();
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
