import 'package:careshare/core/presentation/loading_page_template.dart';
import 'package:careshare/home_page/home_page.dart';
import 'package:careshare/notifications/cubit/notifications_cubit.dart';
import 'package:careshare/notifications/initialise_notifications.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FetchMyNotificationsPage extends StatelessWidget {
  static const routeName = '/fetch-my-notifications-page';

  const FetchMyNotificationsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('fetching my Notifications');

    // initialiseNotifications();

    BlocProvider.of<NotificationsCubit>(context).fetchNotifications();

    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        if (state is NotificationsLoading) {
          return const LoadingPageTemplate(loadingMessage: 'Loading Notifications....');
        }
        if (state is NotificationsError) {
          // return ErrorPageTemplate(errorMessage: state.message);
        }
        if (state is NotificationsLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushReplacementNamed(
                context,
                HomePage.routeName,
              ));
          return Container();
        }
        return Container();
      },
    );
  }
}
