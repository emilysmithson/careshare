import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../domain/errors/story_manager_exception.dart';
import '../domain/models/story.dart';
import '../infrastructure/datasources/story_datasouce.dart';

class StoryDatasourceImpl implements StoryDatasource {

  @override
  Future<String> createStory(Story story) async {
    DatabaseReference reference = FirebaseDatabase.instance.ref("stories");
    final String newkey = reference.push().key as String;
    reference.child(newkey).set(story.toJson());

    return newkey;
  }

  @override
  Future editStory(Story story) async {
    DatabaseReference reference =
    FirebaseDatabase.instance.ref("stories/${story.id}");

    await reference.set(story.toJson());
  }


  // FirebaseFirestore.instance
  //     .collection('users')
  //     .where('age', isGreaterThan: 20)
  //     .get()
  //     .then(...);

  @override
  Future<DatabaseEvent> fetchStorys({String? search}) async {
    DatabaseReference reference;
    if (search == null) {
      reference = FirebaseDatabase.instance.ref("stories");
    }
    else {
      reference = FirebaseDatabase.instance.ref("stories/"+search);
    }
    final response = await reference.once();

    return response;
  }

  @override
  Future updateStory(Story story) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("stories/${story.id}");

    await reference.set(story.toJson());
  }

  @override
  Future<DatabaseEvent> fetchAStory(String id) async {
    DatabaseReference reference =
    FirebaseDatabase.instance.ref("stories/$id");

    final response = await reference.once();
    return response;
  }

  @override
  Future<DatabaseEvent> fetchMyStory() async {

    String? authId = FirebaseAuth.instance.currentUser?.uid;
    // print('fetchMyStory: authId: $authId');
    Query query = FirebaseDatabase.instance.ref("stories") .orderByChild("auth_id").equalTo(authId).limitToFirst(1);

    final response = await query.once();
    return response;
  }


  @override
  Future removeAStory(String storyId) async {
    DatabaseReference reference =
    FirebaseDatabase.instance.ref("stories/$storyId");
    reference.remove();
  }

  @override
  Future<Either<StoryManagerException, bool>> saveStoryPhoto(File photo) {
    // TODO: implement saveStoryPhoto
    throw UnimplementedError();
  }
}
