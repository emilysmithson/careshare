import 'dart:ui';

import 'package:careshare/authentication/cubit/authentication_cubit.dart';
import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/caregroup_manager/repository/add_carer_in_caregroup_to_caregroup.dart';
import 'package:careshare/caregroup_manager/repository/create_a_caregroup.dart';
import 'package:careshare/caregroup_manager/repository/edit_caregroup_field_repository.dart';
import 'package:careshare/caregroup_manager/repository/remove_a_caregroup.dart';
import 'package:careshare/invitation_manager/cubit/invitations_cubit.dart';
import 'package:careshare/invitation_manager/cubit/my_invitations_cubit.dart';
import 'package:careshare/invitation_manager/repository/edit_invitation_field_repository.dart';
import 'package:careshare/notifications/cubit/notifications_cubit.dart';
import 'package:careshare/profile_manager/repository/complete_task.dart';
import 'package:careshare/profile_manager/repository/give_kudos.dart';
import 'package:careshare/router/app_router.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/presentation/custom_theme.dart';

import 'firebase_options.dart';
import 'profile_manager/cubit/all_profiles_cubit.dart';
import 'profile_manager/cubit/my_profile_cubit.dart';
import 'profile_manager/repository/add_carer_in_caregroup_to_profile.dart';
import 'profile_manager/repository/edit_profile_field_repository.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationCubit(),
      child: BlocProvider(
        create: (context) => CaregroupCubit(
          createACaregroupRepository: CreateACaregroup(),
          editCaregroupFieldRepository: EditCaregroupFieldRepository(),
          removeACaregroupRepository: RemoveACaregroup(),
          addCarerInCaregroupToCaregroup: AddCarerInCaregroupToCaregroup(),
        ),
      child: BlocProvider(
      create: (context) => NotificationsCubit(),
          child: BlocProvider(
            create: (context) => MyInvitationsCubit(),
            child: BlocProvider(
              create: (context) => InvitationsCubit(
                editInvitationFieldRepository: EditInvitationFieldRepository(),
                ),
                child: BlocProvider(
                  create: (context) => MyProfileCubit(
                    editProfileFieldRepository: EditProfileFieldRepository(),
                    addCarerInCaregroupToProfile: AddCarerInCaregroupToProfile(),
                    giveKudos: GiveKudos(),
                    completeTask: CompleteTask(),
                  ),
                  child: BlocProvider(
                    create: (context) => AllProfilesCubit(
                      addCarerInCaregroupToProfile: AddCarerInCaregroupToProfile(),
                      editProfileFieldRepository: EditProfileFieldRepository(),
                      completeTask: CompleteTask(),
                      giveKudos: GiveKudos(),
                    ),
                    child: MaterialApp(
                    scrollBehavior: const MaterialScrollBehavior().copyWith(
                      dragDevices: {
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.touch,
                        PointerDeviceKind.stylus,
                        PointerDeviceKind.unknown
                      },
                    ),
                    navigatorKey: navigatorKey,
                    theme: CustomTheme.themeData,
                    onGenerateRoute: _appRouter.onGenerateRoute,
                    ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
