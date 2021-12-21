import 'package:careshare/profile_manager/domain/models/profile.dart';
import 'package:careshare/profile_manager/domain/usecases/all_profile_usecases.dart';
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
