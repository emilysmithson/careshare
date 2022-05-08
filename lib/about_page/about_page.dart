import 'dart:io';

import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';

import 'package:careshare/profile_manager/presenter/profile_widgets/profile_input_field_widget.dart';
import 'package:careshare/widgets/upload_profile_photo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AboutPage extends StatelessWidget {
  static const routeName = '/about-page';


  const AboutPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double spacing = 16;
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Careshare'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Careshare is the genius idea of Emily and Tina...')

            ],
          )

        ),
      ),
    );
  }
}
