// import 'package:careshare/caregroup_manager/models/caregroup.dart';
// import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
// import 'package:careshare/caregroup_manager/presenter/caregroup_overview.dart';
// import 'package:careshare/caregroup_manager/presenter/view_caregroup.dart';
// import 'package:careshare/templates/page_scaffold.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../profile_manager/cubit/profile_cubit.dart';
//
// class CaregroupManagerView extends StatefulWidget {
//   static const String routeName = "/caregroup-manager";
//   const CaregroupManagerView({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _CaregroupManagerViewState createState() => _CaregroupManagerViewState();
// }
//
// class _CaregroupManagerViewState extends State<CaregroupManagerView> {
//   @override
//   Widget build(BuildContext context) {
//     return PageScaffold(
//       floatingActionButton: FloatingActionButton(
//           onPressed: () async {
//             // Create a draft caregroup and pass it to the edit screen
//             final caregroupCubit = BlocProvider.of<CaregroupCubit>(context);
//             final Caregroup? caregroup =
//                 await caregroupCubit.draftCaregroup('');
//             if (caregroup != null) {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                     builder: (_) => BlocProvider.value(
//                           value: BlocProvider.of<CaregroupCubit>(context),
//                           child: BlocProvider.value(
//                             value: BlocProvider.of<ProfileCubit>(context),
//                             child: ViewCaregroup(
//                               caregroup: caregroup,
//                             ),
//                           ),
//                         )),
//               );
//             }
//           },
//           child: const Icon(Icons.add)),
//       body: BlocBuilder<CaregroupCubit, CaregroupState>(
//           builder: (context, state) {
//         if (state is CaregroupLoading) {
//           print('show circular progress indicator C1');
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//
//         if (state is CaregroupLoaded) {
//           if (state.caregroupList.isEmpty) {
//             return const Center(
//               child: Text('no caregroups'),
//             );
//           }
//
//           // return CaregroupsOverview(caregroupList: state.caregroupList, caregroup: widget.caregroup,);
//           return const CaregroupsManager();
//         }
//
//         return const Center(
//           child: Text('Oops something went wrong'),
//         );
//       }),
//     );
//   }
// }
