import 'package:careshare/about_page/about_page.dart';
import 'package:careshare/authentication/presenter/authentication_page.dart';
import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';

import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/fetch_caregroup_page.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_notes.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup_tasks.dart';
import 'package:careshare/caregroup_manager/repository/add_carer_in_caregroup_to_caregroup.dart';
import 'package:careshare/caregroup_manager/repository/remove_a_caregroup.dart';
import 'package:careshare/category_manager/presenter/fetch_categories_page.dart';
import 'package:careshare/home_page/home_page.dart';
import 'package:careshare/caregroup_manager/presenter/edit_caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/invite_user_to_caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup.dart';
import 'package:careshare/caregroup_manager/repository/create_a_caregroup.dart';
import 'package:careshare/caregroup_manager/repository/edit_caregroup_field_repository.dart';
import 'package:careshare/category_manager/cubit/category_cubit.dart';
import 'package:careshare/invitation_manager/cubit/invitations_cubit.dart';
import 'package:careshare/invitation_manager/presenter/fetch_my_invitations_page.dart';
import 'package:careshare/invitation_manager/repository/edit_invitation_field_repository.dart';
import 'package:careshare/note_manager/cubit/note_cubit.dart';
import 'package:careshare/note_manager/cubit/notes_cubit.dart';
import 'package:careshare/note_manager/models/note.dart';
import 'package:careshare/note_manager/presenter/fetch_notes_page.dart';
import 'package:careshare/note_manager/presenter/note_detailed_view.dart';
import 'package:careshare/note_manager/repository/add_delta.dart';
import 'package:careshare/note_manager/repository/create_note.dart';
import 'package:careshare/note_manager/repository/edit_note_field_repository.dart';
import 'package:careshare/note_manager/repository/remove_note.dart';
import 'package:careshare/note_manager/repository/update_a_note.dart';
import 'package:careshare/notification_manager/presenter/fetch_my_notifications.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/notification_manager/presenter/notifications_page.dart';
import 'package:careshare/profile_manager/presenter/edit_my_profile.dart';
import 'package:careshare/profile_manager/presenter/edit_profile.dart';
import 'package:careshare/profile_manager/presenter/fetch_my_profile_page.dart';
import 'package:careshare/profile_manager/presenter/fetch_profiles_page.dart';
import 'package:careshare/profile_manager/presenter/new_profile.dart';
import 'package:careshare/profile_manager/presenter/profile_manager.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_summary.dart';
import 'package:careshare/profile_manager/presenter/view_profile_in_caregroup.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:careshare/task_manager/presenter/fetch_tasks_page.dart';
import 'package:careshare/task_manager/presenter/task_category_view/task_category_view.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/task_detailed_view.dart';
import 'package:careshare/task_manager/presenter/task_search/task_search.dart';
import 'package:careshare/task_manager/repository/create_a_task.dart';
import 'package:careshare/task_manager/repository/edit_task_field_repository.dart';
import 'package:careshare/task_manager/repository/remove_a_task.dart';
import 'package:careshare/task_manager/repository/update_a_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  final _caregroupCubit = CaregroupCubit(
    createACaregroupRepository: CreateACaregroup(),
    editCaregroupFieldRepository: EditCaregroupFieldRepository(),
    removeACaregroupRepository: RemoveACaregroup(),
    addCarerInCaregroupToCaregroup: AddCarerInCaregroupToCaregroup(),
  );
  final _invitationCubit = InvitationsCubit(
    editInvitationFieldRepository: EditInvitationFieldRepository(),
  );
  final _taskCubit = TaskCubit(
    createATaskRepository: CreateATask(),
    editTaskFieldRepository: EditTaskFieldRepository(),
    removeATaskRepository: RemoveATask(),
    updateATaskRepository: UpdateATask(),
  );

  final _notesCubit = NotesCubit(
    editNoteFieldRepository: EditNoteFieldRepository(),
    updateANoteRepository: UpdateANote(),
    createNoteRepository: CreateNote(),
    removeNoteRepository: RemoveNote(),
  );

  final _noteCubit = NoteCubit(
    addDeltaRepository: AddDelta(),

  );

  // final _chatCubit = ChatCubit(
  //   createChatRepository: CreateChat(),
  //   removeChatRepository: RemoveChat(),
  // );

  final _categoriesCubit = CategoriesCubit();

  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AuthenticationPage.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _caregroupCubit,
            child: BlocProvider.value(
              value: _taskCubit,
              child: BlocProvider.value(
                value: _invitationCubit,
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
            value: _caregroupCubit,
            child: const HomePage(),
          ),
        );

      case AboutPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const AboutPage(),
        );

      // case CaregroupManager.routeName:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider.value(
      //       value: _caregroupCubit,
      //       child: const CaregroupManager(),
      //     ),
      //   );

      // case TaskManagerView.routeName:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider.value(
      //       value: _taskCubit,
      //       child: BlocProvider.value(
      //         value: _categoriesCubit,
      //         child: TaskManagerView(
      //           caregroup: routeSettings.arguments as Caregroup,
      //         ),
      //       ),
      //     ),
      //   );

      case TaskSearch.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _taskCubit,
            child: BlocProvider.value(
              value: _categoriesCubit,
              child: TaskSearch(
                selectedStatuses:
                    (routeSettings.arguments as Map<String, dynamic>)['selectedStatuses'] as List<TaskStatus>?,
                selectedProfiles:
                    (routeSettings.arguments as Map<String, dynamic>)['selectedProfiles'] as List<Profile>?,
                // selectedCategories: (routeSettings.arguments as Map<String, dynamic>)['selectedCategories'] as List<CareCategory>?,
              ),
            ),
          ),
        );

      case TaskDetailedView.routeName:
        CareTask? task;
        if (routeSettings.arguments.runtimeType == String) {
          task = _taskCubit.fetchTaskFromID(routeSettings.arguments as String);
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _taskCubit,
            child: BlocProvider.value(
              value: _caregroupCubit,
              child: BlocProvider.value(
                value: _categoriesCubit,
                child: TaskDetailedView(task: task ?? routeSettings.arguments as CareTask),
              ),
            ),
          ),
        );

      case NoteDetailedView.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _noteCubit..fetchNote(noteId: (routeSettings.arguments as Map<String, dynamic>)['noteId'] as String),
            child: NoteDetailedView(
              caregroup: (routeSettings.arguments as Map<String, dynamic>)['caregroup'] as Caregroup,
              noteId: (routeSettings.arguments as Map<String, dynamic>)['noteId'] as String,
            ),
          ),
        );

      case InviteUserToCaregroup.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _caregroupCubit,
            child: BlocProvider.value(
              value: _invitationCubit,
              child: InviteUserToCaregroup(caregroup: routeSettings.arguments as Caregroup),
            ),
          ),
        );

      case TaskCategoryView.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _taskCubit,
            child: BlocProvider.value(
              value: _categoriesCubit,
              child: TaskCategoryView(
                  careTaskList: (routeSettings.arguments as Map<String, dynamic>)['careTaskList'] as List<CareTask>,
                  title: (routeSettings.arguments as Map<String, dynamic>)['title']),
            ),
          ),
        );

      case ProfileSummary.routeName:
        return MaterialPageRoute(
          builder: (_) => ProfileSummary(profile: routeSettings.arguments as Profile),
        );
      case ProfilesManager.routeName:
        return MaterialPageRoute(
          builder: (_) => const ProfilesManager(),
        );

      case EditProfile.routeName:
        return MaterialPageRoute(
          builder: (_) => EditProfile(profile: routeSettings.arguments as Profile),
        );

      case EditMyProfile.routeName:
        return MaterialPageRoute(
          builder: (_) => EditMyProfile(),
        );

      case ViewProfileInCaregroup.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _caregroupCubit,
            child: BlocProvider.value(
              value: _taskCubit,
              child: ViewProfileInCaregroup(
                  caregroup: (routeSettings.arguments as Map<String, dynamic>)['caregroup'] as Caregroup,
                  profile: (routeSettings.arguments as Map<String, dynamic>)['profile'] as Profile),
            ),
          ),
        );

      case ViewCaregroup.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _caregroupCubit,
            child: BlocProvider.value(
              value: _categoriesCubit,
              child: BlocProvider.value(
                value: _taskCubit,
                child: ViewCaregroup(caregroup: (routeSettings.arguments as Map<String, dynamic>)['caregroup']),
              ),
            ),
          ),
        );

      case NotificationsPage.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _taskCubit,
            child: NotificationsPage(caregroup: routeSettings.arguments as Caregroup),
          ),
        );

      case EditCaregroup.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _caregroupCubit,
            child: EditCaregroup(caregroup: routeSettings.arguments as Caregroup),
          ),
        );

      case FetchMyProfilePage.routeName:
        if (routeSettings.arguments.runtimeType == String) {
          return MaterialPageRoute(
            builder: (_) => FetchMyProfilePage(id: routeSettings.arguments as String),
          );
        } else {
          final arguments = routeSettings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => FetchMyProfilePage(
              id: arguments['id'],
              createProfile: true,
              photo: arguments['photo'],
              name: arguments['name'],
              email: arguments['email'],
            ),
          );
        }

      case FetchCaregroupPage.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _caregroupCubit,
            child: const FetchCaregroupPage(),
          ),
        );

      case ViewCaregroupTasks.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _taskCubit,
            child: ViewCaregroupTasks(
              caregroup: routeSettings.arguments as Caregroup,
            ),
          ),
        );

      case ViewCaregroupNotes.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _notesCubit,
            child: ViewCaregroupNotes(
              caregroup: routeSettings.arguments as Caregroup,
            ),
          ),
        );

      case FetchTasksPage.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _taskCubit,
            child: FetchTasksPage(
              caregroup: routeSettings.arguments as Caregroup,
            ),
          ),
        );

      case FetchNotesPage.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _notesCubit,
            child: FetchNotesPage(
              caregroup: routeSettings.arguments as Caregroup,
            ),
          ),
        );

      case FetchCategoriesPage.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _categoriesCubit,
            child: FetchCategoriesPage(
              caregroup: routeSettings.arguments as Caregroup,
            ),
          ),
        );

      case NewProfile.routeName:
        return MaterialPageRoute(
          builder: (_) => NewProfile(),
        );

      case FetchProfilesPage.routeName:
        return MaterialPageRoute(
          builder: (_) => FetchProfilesPage(
            caregroup: routeSettings.arguments as Caregroup,
          ),
        );

      // case FetchInvitationsPage.routeName:
      //   return MaterialPageRoute(
      //       builder: (_) => FetchInvitationsPage(
      //           caregroup: routeSettings.arguments as Caregroup,
      //       ),
      //   );

      case FetchMyInvitationsPage.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _caregroupCubit,
            child: const FetchMyInvitationsPage(),
          ),
        );

      case FetchMyNotificationsPage.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _caregroupCubit,
            child: const FetchMyNotificationsPage(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const AuthenticationPage(),
        );
    }
  }
}
