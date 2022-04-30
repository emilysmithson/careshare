import 'package:careshare/notifications/presenter/cubit/notifications_cubit.dart';
import 'package:careshare/notifications/presenter/notifications_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BellWidget extends StatelessWidget {
  const BellWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
      if (state is NotificationsLoaded) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, NotificationsPage.routeName);
          },
          child: SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Center(child: Icon(Icons.notifications)),
                if (state.numberOfNewNotifications > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      height: 18,
                      width: 18,
                      child: Center(
                        child: Text(
                          state.numberOfNewNotifications < 10
                              ? state.numberOfNewNotifications.toString()
                              : '9+',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }
      return Container();
    });
  }
}
