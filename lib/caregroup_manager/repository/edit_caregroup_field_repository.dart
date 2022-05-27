import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditCaregroupFieldRepository {
  Future<Caregroup> call(
      {required Caregroup caregroup,
      required CaregroupField caregroupField,
      required dynamic newValue}) async {
    Caregroup newCaregroup = caregroup;
    late String field;
    // ignore: prefer_typing_uninitialized_variables
    late var value;
    switch (caregroupField) {
      case CaregroupField.name:
        newCaregroup.name = newValue;
        field = 'name';
        value = newValue;
        break;
      case CaregroupField.details:
        newCaregroup.name = newValue;
        field = 'details';
        value = newValue;
        break;
      case CaregroupField.test:
        newCaregroup.test = newValue;
        field = 'test';
        value = newValue;
        break;
      case CaregroupField.status:
        newCaregroup.status = newValue;
        field = 'status';
        value = newValue.status;
        break;
      case CaregroupField.type:
        newCaregroup.type = newValue;
        field = 'type';
        value = newValue.type;
        break;
      case CaregroupField.createdDate:
        newCaregroup.createdDate = newValue;
        field = 'created_date';
        value = newValue;
        break;
      case CaregroupField.createdBy:
        newCaregroup.createdBy = newValue;
        field = 'created_by';
        value = newValue;
        break;
      case CaregroupField.lastReminders:
        newCaregroup.lastReminders = newValue;
        field = 'last_reminders';
        value = newValue;
        break;
      case CaregroupField.photo:
        final ref = FirebaseStorage.instance
            .ref()
            .child('caregroup_photos')
            .child(FirebaseAuth.instance.currentUser!.uid + '.jpg');

        await ref.putFile(newValue);
        final url = await ref.getDownloadURL();
        newCaregroup.photo = url;
        field = 'photo';
        value = url;
        break;
    }

    DatabaseReference reference =
        FirebaseDatabase.instance.ref("caregroups/${caregroup.id}/$field");

    reference.set(value);
    return newCaregroup;
  }
}
