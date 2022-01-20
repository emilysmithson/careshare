// // ignore_for_file: invalid_use_of_protected_member

// import 'package:careshare/authentication/cubit/authentication_cubit.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class AuthenticationController {
//   final formKey = GlobalKey<FormState>();
//   final emailAdressController = TextEditingController();
//   final passwordController = TextEditingController();
//   bool hidePassword = true;
//   bool resetSent = false;
//   bool forgottenPassword = false;
//   final register = ValueNotifier<bool>(true);

//   Future authenticate(BuildContext context) async {
//     final authenticationCubit = BlocProvider.of<AuthenticationCubit>(context);
//     if (formKey.currentState!.validate()) {
//       authenticationCubit.register(
//           email: emailAdressController.text, password: passwordController.text);
//     } else {
//       authenticationCubit.signIn(
//           email: emailAdressController.text, password: passwordController.text);
//     }
//   }

//   void sendPasswordReminder(
//     BuildContext context,
//   ) {
//     final authenticationCubit = BlocProvider.of<AuthenticationCubit>(context);
//     authenticationCubit.resetPassword(email: emailAdressController.text);
//   }
// }
