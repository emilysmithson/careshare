import 'package:careshare/notifications/presenter/cubit/notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BellWidget extends StatelessWidget {
  const BellWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit(),
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsInitial) {
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {},
                ),
                if (state.numberOfNewNotifications != 0)
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
                  )
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
