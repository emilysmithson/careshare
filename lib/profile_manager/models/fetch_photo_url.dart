import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<String> fetchPhotoUrl(String photo) async {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  return firebase_storage.FirebaseStorage.instance.ref(photo).getDownloadURL();
}
