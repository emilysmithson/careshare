import 'package:bloc/bloc.dart';
import 'package:careshare/notifications/domain/careshare_notification.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());
  List<CareshareNotification> notificationsList = [];
  fetchNotifications() async {
    try {
      DatabaseReference reference = FirebaseDatabase.instance.ref(
        'profiles/${FirebaseAuth.instance.currentUser!.uid}/notifications',
      );
      final response = reference.onValue;
      response.listen((event) {
        emit(NotificationsInitial());
        if (event.snapshot.value == null) {
          emit(
            NotificationsLoaded(
              notificationsList: notificationsList,
              numberOfNewNotifications: numberOfUnreadNotifications(),
            ),
          );
        } else {
          Map<dynamic, dynamic> returnedList =
              event.snapshot.value as Map<dynamic, dynamic>;
          notificationsList.clear();

          returnedList.forEach((key, value) {
            final userdata = Map<String, dynamic>.from(value);
            notificationsList.add(CareshareNotification.fromJson(userdata));
          });

          notificationsList.sort(
            (a, b) => a.dateTime.compareTo(b.dateTime),
          );

          emit(
            NotificationsLoaded(
              notificationsList: notificationsList,
              numberOfNewNotifications: numberOfUnreadNotifications(),
            ),
          );
        }
      });
    } catch (error) {
      emit(NotificationsError(error.toString()));
    }
  }

  sendNotifcations({
    required CareshareNotification notification,
    required List<String> recipients,
  }) {
    for (final String recipient in recipients) {
      DatabaseReference reference = FirebaseDatabase.instance
          .ref('profiles/${recipient}/notifications');

      reference.child(notification.id).set(
            notification.toJson(),
          );

      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('notifyUsers');
      callable.call(
        notification.toJson(),
      );
    }
  }

  markAsRead(String notificationID) async {
    try {
      DatabaseReference reference = FirebaseDatabase.instance.ref(
        'profiles/${FirebaseAuth.instance.currentUser!.uid}/notifications/$notificationID/is_read',
      );

      reference.set(true);
    } catch (error) {
      emit(NotificationsError(error.toString()));
    }
  }

  deleteNotification(String notificationID) async {
    try {
      DatabaseReference reference = FirebaseDatabase.instance.ref(
        'profiles/${FirebaseAuth.instance.currentUser!.uid}/notifications/$notificationID',
      );

      reference.remove();
      notificationsList.clear();
      emit(NotificationsLoaded(
          notificationsList: notificationsList,
          numberOfNewNotifications: numberOfUnreadNotifications()));
    } catch (error) {
      emit(NotificationsError(error.toString()));
    }
  }

  int numberOfUnreadNotifications() {
    return notificationsList
        .where(
          (element) => !element.isRead,
        )
        .toList()
        .length;
  }
}
