// import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
// import 'package:careshare/caregroup_manager/presenter/caregroup_summary.dart';
// import 'package:careshare/templates/page_scaffold.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class CaregroupsManager extends StatelessWidget {
//   static const String routeName = "/caregroups-manager";
//   const CaregroupsManager({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CaregroupCubit, CaregroupState>(
//       builder: (context, state) {
//         if (state is CaregroupLoaded) {
//           return PageScaffold(
//             body: SingleChildScrollView(
//               child: Wrap(
//                 children: state.caregroupList
//                     .map(
//                       (caregroup) => CaregroupSummary(
//                         caregroup: caregroup,
//                       ),
//                     )
//                     .toList(),
//               ),
//             ),
//           );
//         }
//
//         return const Center(child: CircularProgressIndicator());
//       },
//     );
//   }
// }
