import 'package:careshare/profile/domain/models/profile.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class ProfileDatasource {
  Future<Profile> addProfile(Profile profile);
  Future<DatabaseEvent> fetchProfiles();
}
