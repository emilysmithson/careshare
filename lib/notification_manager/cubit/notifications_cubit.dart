import 'package:bloc/bloc.dart';
import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/notification_manager/models/careshare_notification.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:careshare/profile_manager/models/profile.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());
  List<CareshareNotification> notificationsList = [];

  // fetchNotifications
  fetchNotifications() async {
    try {
      emit(const NotificationsLoading());

      final reference = FirebaseDatabase.instance.ref(
        'profiles/${FirebaseAuth.instance.currentUser!.uid}/notifications',
      );
      final response = reference.onValue;
      response.listen((event) {
        emit(NotificationsInitial());
        if (event.snapshot.value == null) {
          emit(
            NotificationsLoaded(
              notificationsList: notificationsList,
            ),
          );
        } else {
          Map<dynamic, dynamic> returnedList = event.snapshot.value as Map<dynamic, dynamic>;
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
            ),
          );
        }
      });
    } catch (error) {
      emit(NotificationsError(error.toString()));
    }
  }

  // sendNotifications
  sendNotifications({
    required CareshareNotification notification,
    required List<String> recipients,
  }) {
    for (final String recipient in recipients) {

      // save to the profile/notifocations
      final reference = FirebaseDatabase.instance.ref('profiles/$recipient/notifications');
      reference.child(notification.id).set(
            notification.toJson(),
          );

      // send the notification
      final callable = FirebaseFunctions.instance.httpsCallable('notifyUsers');
      callable.call(
        {
          'id': notification.id,
          'title': notification.title,
          'route': notification.routeName,
          'subtitle': notification.subtitle,
          'sender_id': notification.senderId,
          'recipient_id': recipient,
          'date_time': notification.dateTime.toString(),
          'arguments': notification.arguments,
        },
      );
    }
  }

  // notifyEveryoneInMyCareGroupApartFromMe({
  //   required CareshareNotification notification,
  //   required Caregroup caregroup,
  //   required String userId,
  //   required List<Profile> profileList,
  // }) {
  //   List<String> recipients = [];
  //
  //   final profilesInCaregroupExceptMe = profileList.where((profile) =>
  //       profile.id != userId &&
  //       profile.carerInCaregroups.indexWhere((element) => element.caregroupId == caregroup.id) != -1);
  //
  //   for (final Profile profile in profilesInCaregroupExceptMe) {
  //     recipients.add(profile.id);
  //   }
  //
  //   if (recipients.isNotEmpty) {
  //     sendNotifications(notification: notification, recipients: recipients);
  //   }
  // }

  markAsRead(String notificationID) async {
    try {
      final reference = FirebaseDatabase.instance.ref(
        'profiles/${FirebaseAuth.instance.currentUser!.uid}/notifications/$notificationID/is_read',
      );

      reference.set(true);
    } catch (error) {
      emit(NotificationsError(error.toString()));
    }
  }

  markAllAsRead() {
    for (CareshareNotification notification in notificationsList) {
      markAsRead(notification.id);
    }
  }

  deleteNotification(String notificationID) async {
    try {
      final reference = FirebaseDatabase.instance.ref(
        'profiles/${FirebaseAuth.instance.currentUser!.uid}/notifications/$notificationID',
      );

      reference.remove();
      notificationsList.clear();
      emit(NotificationsLoaded(
        notificationsList: notificationsList,
      ));
    } catch (error) {
      emit(NotificationsError(error.toString()));
    }
  }

  deleteAllNotifications(Caregroup caregroup) {
    for (final CareshareNotification notification in notificationsList.where((n) => n.caregroupId == caregroup.id)) {
      deleteNotification(notification.id);
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
