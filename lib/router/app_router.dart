import 'package:careshare/authentication/cubit/authentication_cubit.dart';
import 'package:careshare/authentication/presenter/authentication_page.dart';
import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/caregroup_picker.dart';
import 'package:careshare/caregroup_manager/presenter/edit_caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup.dart';
import 'package:careshare/caregroup_manager/repository/create_a_caregroup.dart';
import 'package:careshare/caregroup_manager/repository/edit_caregroup_field_repository.dart';
import 'package:careshare/category_manager/cubit/category_cubit.dart';
import 'package:careshare/home_page/home_page.dart';
import 'package:careshare/notifications/presenter/notifications_page.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/presenter/edit_profile.dart';
import 'package:careshare/profile_manager/presenter/profile_manager.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_summary.dart';
import 'package:careshare/profile_manager/presenter/view_profile.dart';
import 'package:careshare/profile_manager/repository/complete_task.dart';
import 'package:careshare/profile_manager/repository/edit_profile_field_repository.dart';
import 'package:careshare/profile_manager/repository/give_kudos.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/presenter/task_category_view/task_category_view.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/task_detailed_view.dart';
import 'package:careshare/task_manager/presenter/task_manager_view.dart';
import 'package:careshare/task_manager/repository/create_a_task.dart';
import 'package:careshare/task_manager/repository/edit_task_field_repository.dart';
import 'package:careshare/task_manager/repository/remove_a_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../profile_manager/models/profile.dart';
import '../task_manager/models/task.dart';

class AppRouter {
  final _profileCubit = ProfileCubit(
    editProfileFieldRepository: EditProfileFieldRepository(),
    giveKudos: GiveKudos(),
    completeTask: CompleteTask(),
  );
  final _caregroupCubit = CaregroupCubit(
    createACaregroupRepository: CreateACaregroup(),
    editCaregroupFieldRepository: EditCaregroupFieldRepository(),
  );
  final _taskCubit = TaskCubit(
    createATaskRepository: CreateATask(),
    editTaskFieldRepository: EditTaskFieldRepository(),
    removeATaskRepository: RemoveATask(),
  );
  final _categoriesCubit = CategoriesCubit();
  final _authenticationCubit = AuthenticationCubit();

  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AuthenticationPage.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _profileCubit,
            child: BlocProvider.value(
              value: _caregroupCubit,
              child: BlocProvider.value(
                value: _taskCubit,
                child: BlocProvider.value(
                  value: _categoriesCubit,
                  child: const AuthenticationPage(),
                ),
              ),
            ),
          ),
        );

      case HomePage.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _profileCubit,
            child: BlocProvider.value(
              value: _authenticationCubit,
              child: const HomePage(),
            ),
          ),
        );

      case TaskManagerView.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _profileCubit,
            child: BlocProvider.value(
              value: _taskCubit,
              child: BlocProvider.value(
                value: _categoriesCubit,
                child: TaskManagerView(caregroup: routeSettings.arguments as Caregroup),
              ),
            ),
          ),
        );
      case TaskDetailedView.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _profileCubit,
            child: BlocProvider.value(
              value: _taskCubit,
              child: BlocProvider.value(
                value: _categoriesCubit,
                child:
                    TaskDetailedView(task: routeSettings.arguments as CareTask),
              ),
            ),
          ),
        );
      case TaskCategoryView.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _profileCubit,
            child: BlocProvider.value(
              value: _taskCubit,
              child: BlocProvider.value(
                value: _categoriesCubit,
                child: TaskCategoryView(
                    careTaskList: (routeSettings.arguments
                            as Map<String, dynamic>)['careTaskList']
                        as List<CareTask>,
                    title: (routeSettings.arguments
                        as Map<String, dynamic>)['title']),
              ),
            ),
          ),
        );
      case ProfileSummary.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _profileCubit,
            child: ProfileSummary(profile: routeSettings.arguments as Profile),
          ),
        );
      case ProfilesManager.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _profileCubit,
            child: const ProfilesManager(),
          ),
        );
      case EditProfile.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _profileCubit,
            child: EditProfile(profile: routeSettings.arguments as Profile),
          ),
        );

      case ViewProfile.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _profileCubit,
              child: BlocProvider.value(
                value: _caregroupCubit,
                  child: ViewProfile(
                      caregroup: (routeSettings.arguments
                      as Map<String, dynamic>)['caregroup']
                      as  Caregroup,
                      profile: (routeSettings.arguments
                      as Map<String, dynamic>)['profile'] as Profile

                ),
            ),
          )
        );

      case ViewCaregroup.routeName:
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                value: _profileCubit,
                child: BlocProvider.value(
                  value: _caregroupCubit,
                  child: ViewCaregroup(caregroup: routeSettings.arguments as Caregroup),
              )
            )
        );


      case NotificationsPage.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _profileCubit,
            child: BlocProvider.value(
              value: _taskCubit,
              child: const NotificationsPage(),
            ),
          ),
        );

      case CaregroupPicker.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _caregroupCubit,
            child: BlocProvider.value(
              value: _profileCubit ,
              child: CaregroupPicker(),
            ),
          ),
        );

      // case CaregroupManagerView.routeName:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider.value(
      //       value: _profileCubit,
      //       child: BlocProvider.value(
      //         value: _taskCubit,
      //         child: BlocProvider.value(
      //           value: _caregroupCubit,
      //           child: const CaregroupManagerView(),
      //         ),
      //       ),
      //     ),
      //   );

      // case CaregroupsManager.routeName:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider.value(
      //       value: _profileCubit,
      //       child: BlocProvider.value(
      //         value: _caregroupCubit,
      //         child: const CaregroupsManager(),
      //       ),
      //     ),
      //   );

      case EditCaregroup.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _caregroupCubit,
            child: EditCaregroup(caregroup: routeSettings.arguments as Caregroup),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _profileCubit,
            child: BlocProvider.value(
              value: _taskCubit,
              child: BlocProvider.value(
                value: _categoriesCubit,
                child: const AuthenticationPage(),
              ),
            ),
          ),
        );
    }
  }
}
