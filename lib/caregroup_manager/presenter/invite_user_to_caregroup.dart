import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/invitation_manager/cubit/invitations_cubit.dart';
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
      child: BlocBuilder<InvitationsCubit, InvitationsState>(
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
                            'Invite someome to join the ${widget.caregroup.name} caregroup by providing their email address and adding an optional message.'),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: widget.emailController,
                          decoration: const InputDecoration(
                            label: Text('Email '),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter an email address';
                            }
                            bool emailValid =
                                RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[-a-zA-Z0-9]+\.[a-zA-Z]+")
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
                                  BlocProvider.of<InvitationsCubit>(context).sendInvitation(
                                    id: DateTime.now().millisecondsSinceEpoch.toString(),
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
