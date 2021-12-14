import 'package:careshare/profile/domain/models/profile.dart';
import 'package:careshare/profile/domain/usecases/profile_usecases.dart';
import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';

class ProfileController {
  fetchAllProfiles() async {
    final response = await ProfileUsecases.fetchProfiles();
    final nameController = TextEditingController();
    print(response);
  }
}
