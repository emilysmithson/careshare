import 'package:careshare/authentication/cubit/authentication_cubit.dart';
import 'package:careshare/authentication/presenter/authentication_page.dart';
import 'package:careshare/category_manager/cubit/category_cubit.dart';
import 'package:careshare/home_page/cubit/home_page_cubit.dart';
import 'package:careshare/home_page/presenter/homepage.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/repository/edit_profile_field_repository.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';

import 'package:careshare/task_manager/repository/create_a_task.dart';
import 'package:careshare/task_manager/repository/edit_task_field_repository.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/presentation/custom_theme.dart';
import 'task_manager/repository/remove_a_task.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
        theme: CustomTheme.themeData,
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthenticationCubit()..checkAuthentication(),
            ),
            BlocProvider(
              create: (context) => ProfileCubit(
                editProfileFieldRepository: EditProfileFieldRepository(),
              ),
            ),
            BlocProvider(
              create: (context) => CategoriesCubit(),
            ),
            BlocProvider(
              create: (context) => TaskCubit(
                removeATaskRepository: RemoveATask(),
                createATaskRepository: CreateATask(),
                editTaskFieldRepository: EditTaskFieldRepository(),
              ),
            ),
            BlocProvider(
              create: (context) => HomePageCubit(),
            ),
          ],
          child: const App(),
        )),
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool isLoading = true;
  initialiseHomePage(BuildContext context) async {
    await BlocProvider.of<ProfileCubit>(context).fetchProfiles();
    await BlocProvider.of<TaskCubit>(context).fetchTasks();

    await BlocProvider.of<CategoriesCubit>(context).fetchCategories();
    // await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationLoaded) {
          if (isLoading) {
            initialiseHomePage(context);
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const HomePage();
        }
        return const AuthenticationPage();
      },
    );
  }
}
