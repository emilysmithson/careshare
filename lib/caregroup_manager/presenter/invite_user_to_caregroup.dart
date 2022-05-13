import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/invitation_manager/cubit/invitation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Define a custom Form widget.
class InviteUserToCaregroup extends StatefulWidget {
  static const String routeName = "/invite-user-to-caregroup";
  final Caregroup caregroup;

  InviteUserToCaregroup({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  InviteUserToCaregroupState createState() {
    return InviteUserToCaregroupState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class InviteUserToCaregroupState extends State<InviteUserToCaregroup> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<InviteUserToCaregroupState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Invitation invitation = Invitation(
    //     caregroupId: widget.caregroup.id,
    //     id: DateTime.now().millisecondsSinceEpoch.toString(),
    //     email: '',
    //     invitedById: FirebaseAuth.instance.currentUser!.uid,
    //     invitedDate: DateTime.now(),
    //     status: InvitationStatus.invited,
    // );

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: BlocBuilder<InvitationCubit, InvitationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Invite person to Caregroup'),
              actions: const [],
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                            'Invite someome to joing the ${widget.caregroup.name} caregroup by providing their email address and adding an optional message.'),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: widget.emailController,
                          decoration: const InputDecoration(
                            label: Text('Email '),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter your Email address';
                            }
                            bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[-a-zA-Z0-9]+\.[a-zA-Z]+")
                                // r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value);
                            if (!emailValid) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: widget.messageController,
                          decoration: const InputDecoration(
                            label: Text('Message '),
                          ),
                          validator: (value) {
                            return null;
                          },
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<InvitationCubit>(context)
                                      .sendInvitation(
                                    id: DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                    email: widget.emailController.text,
                                    caregroupId: widget.caregroup.id,
                                    message: widget.messageController.text,
                                  );

                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Send Invitation'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

//
//
// class InviteUserToCaregroup extends StatelessWidget {
//   static const String routeName = "/invite-user-to-caregroup";
//   final Caregroup caregroup;
//
//   InviteUserToCaregroup({
//     Key? key,
//     required this.caregroup,
//   }) : super(key: key);
//   final _formKey = GlobalKey<FormState>();
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     Invitation invitation = Invitation(
//         caregroupId: caregroup.id,
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         email: '',
//         invitedById: FirebaseAuth.instance.currentUser!.uid,
//         invitedDate: DateTime.now()
//     );
//
//     return GestureDetector(
//       onTap: () {
//         FocusScopeNode currentFocus = FocusScope.of(context);
//         if (!currentFocus.hasPrimaryFocus) {
//           currentFocus.unfocus();
//         }
//       },
//       child: BlocBuilder<InvitationCubit, InvitationState>(
//         builder: (context, state) {
//           return Scaffold(
//             floatingActionButton: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Row(
//                   children: [
//
//                       ElevatedButton(
//                         onPressed: ()  {
//                           Navigator.pop(context);
//                         },
//                         child: const Text('Cancel'),
//                       ),
//
//                       SizedBox(width:20),
//
//
//                     ElevatedButton(
//                         onPressed: () async {
//                           // Profile myProfile = BlocProvider.of<ProfileCubit>(context).myProfile;
//                           //
//                           // BlocProvider.of<InvitationCubit>(context).sendInvitation(
//                           //   invitation: invitation,
//                           //   id: myProfile.id!,
//                           // );
//                           //
//                           // Navigator.pop(context);
//                           //
//                           // // Send a message to tell the world the invitation is created
//                           // HttpsCallable callable =
//                           // FirebaseFunctions.instance.httpsCallable('sendInvitation');
//                           // final resp = await callable.call(<String, dynamic>{
//                           //   'invitation_id': invitation.id,
//                           //   'invitation_title': invitation.title,
//                           //   'creater_id': myProfile.id,
//                           //   'creater_name': myProfile.name,
//                           //   'date_time': DateTime.now().toString()
//                           // });
//
//                         },
//                         child: const Text('Send Invitation'),
//                       ),
//                     SizedBox(width:20),
//
//                   ],
//                 ),
//                 // InvitationWorkflowWidget(invitation: invitation),
//               ],
//             ),
//             appBar: AppBar(
//               title: const Text('Invite person to Caregroup'),
//               actions: [
//               ],
//             ),
//             body: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: SingleChildScrollView(
//                 child: Wrap(
//                   runSpacing: 24,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 4.0),
//                       child: Text('Invite someome to joing the ${caregroup.name} caregroup by providing their email address and adding an optional message.')
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 4.0),
//                       child: TextFormField(
//                         decoration: const InputDecoration(
//                           label: Text('Email '),
//                         ),
//                         validator: (value) {
//                           if (value == null) {
//                             return 'Please enter your Email address';
//                           }
//                           bool emailValid = RegExp(
//                               r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[-a-zA-Z0-9]+\.[a-zA-Z]+")
//                           // r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                               .hasMatch(value);
//                           if (!emailValid) {
//                             return 'Please enter a valid email address.';
//                           }
//                           return null;
//                         },
//                         keyboardType: TextInputType.emailAddress,
//                       ),
//                     ),
//
//                     InvitationInputFieldWidget(
//                         currentValue: invitation.message,
//                         maxLines: 5,
//                         invitation: invitation,
//                         label: 'Message',
//                         onChanged: (value) {}
//                     ),
//
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
//
//
//
// // import 'package:careshare/category_manager/cubit/category_cubit.dart';
// // import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
// // import 'package:careshare/invitation_manager/cubit/invitation_cubit.dart';
// // import 'package:careshare/invitation_manager/models/invitation.dart';
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// //
// //
// // class InviteUserToCaregroup {
// //   call(BuildContext context) {
// //     TextEditingController textEditingController = TextEditingController();
// //     final TextEditingController emailController = TextEditingController();
// //
// //     onSubmit() async {
// //     //   if (textEditingController.text.isEmpty) {
// //     //     return;
// //     //   }
// //     //   final invitationCubit = BlocProvider.of<InvitationCubit>(context);
// //     //   final CareInvitation? invitation =
// //     //   await invitationCubit.draftInvitation(textEditingController.text,'');
// //     //   if (invitation == null) {
// //     //     Navigator.pop(context);
// //     //   } else {
// //         Navigator.pop(context);
// //         textEditingController.clear();
// //       // }
// //     }
// //
// //     showModalBottomSheet(
// //         context: context,
// //         builder: (context) {
// //           return SingleChildScrollView(
// //               child: SafeArea(
// //                 child: SizedBox(
// //                   height: 600,
// //                   child: Column(
// //                     children: [
// //                       Text(
// //                         'Invite someone to the Caregroup',
// //                         style: Theme.of(context).textTheme.headline6,
// //                       ),
// //                       const SizedBox(height: 10),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: TextFormField(
// //                           controller: emailController,
// //                           decoration: const InputDecoration(
// //                             label: Text('E-mail Address'),
// //                           ),
// //                           validator: (value) {
// //                             if (value == null) {
// //                               return 'Please enter your Email address';
// //                             }
// //                             bool emailValid = RegExp(
// //                                 r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[-a-zA-Z0-9]+\.[a-zA-Z]+")
// //                             // r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
// //                                 .hasMatch(value);
// //                             if (!emailValid) {
// //                               return 'Please enter a valid email address.';
// //                             }
// //                             return null;
// //                           },
// //                           keyboardType: TextInputType.emailAddress,
// //                         ),
// //
// //
// //                         // TextField(
// //                         //   controller: textEditingController,
// //                         //   decoration: const InputDecoration(
// //                         //     label: Text('Enter an email address'),
// //                         //   ),
// //                         //   autofocus: true,
// //                         //   textCapitalization: TextCapitalization.sentences,
// //                         //   onSubmitted: (value) {
// //                         //     onSubmit();
// //                         //   },
// //                         // ),
// //                       ),
// //                       const SizedBox(height: 1),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: TextField(
// //                           controller: textEditingController,
// //                           decoration: const InputDecoration(
// //                             label: Text('Select a role'),
// //                           ),
// //                           autofocus: true,
// //                           textCapitalization: TextCapitalization.sentences,
// //                           onSubmitted: (value) {
// //                             onSubmit();
// //                           },
// //                         ),
// //                       ),
// //                       const SizedBox(height: 1),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: TextField(
// //                           controller: textEditingController,
// //                           decoration: const InputDecoration(
// //                             label: Text('Add a message'),
// //                           ),
// //                           autofocus: true,
// //                           textCapitalization: TextCapitalization.sentences,
// //                           onSubmitted: (value) {
// //                             onSubmit();
// //                           },
// //                         ),
// //                       ),
// //                       const SizedBox(height: 1),
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                         children: [
// //                           ElevatedButton(
// //                             onPressed: () {
// //                               Navigator.pop(context);
// //                             },
// //                             child: const Text('Cancel'),
// //                           ),
// //                           ElevatedButton(
// //                             onPressed: onSubmit,
// //                             child: const Text('Invite'),
// //                           ),
// //                         ],
// //                       )
// //                     ],
// //                   ),
// //                 ),
// //               ));
// //         });
// //   }
// // }
