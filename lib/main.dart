import 'package:careshare/authentication/cubit/authentication_cubit.dart';
import 'package:careshare/authentication/presenter/authentication_page.dart';
import 'package:careshare/categories/cubit/categories_cubit.dart';
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
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

void main() {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
        theme: CustomTheme().call(),
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationLoaded) {
          BlocProvider.of<TaskCubit>(context).fetchTasks();
          BlocProvider.of<ProfileCubit>(context).fetchProfiles();
          BlocProvider.of<CategoriesCubit>(context).fetchCategories();

          return const HomePage();
        }
        return const AuthenticationPage();
      },
    );
  }
}
