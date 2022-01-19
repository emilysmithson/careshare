import 'package:careshare/profile/domain/models/profile.dart';
import 'package:careshare/profile/infrastructure/datasources/profile_datasource.dart';
import 'package:firebase_database/firebase_database.dart';

const String dbName = 'profiles_test';

class ProfileDatasourceImpl implements ProfileDatasource {
  @override
  Future<Profile> addProfile(Profile profile) async {
    DatabaseReference reference = FirebaseDatabase.instance.ref(dbName);

    reference.child(profile.id!).set(profile.toJson());

    return profile;
  }

  @override
  Future<DatabaseEvent> fetchProfiles() async {
    DatabaseReference reference = FirebaseDatabase.instance.ref(dbName);
    final response = await reference.once();

    return response;
  }
}
