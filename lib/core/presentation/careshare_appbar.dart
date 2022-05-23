// import 'package:careshare/home_page/home_page.dart';
// import 'package:careshare/notification_manager/presenter/widgets/bell_widget.dart';
// import 'package:careshare/task_manager/presenter/task_search/task_search.dart';
// import 'package:flutter/material.dart';
//
// class CareshareAppBar extends StatelessWidget with PreferredSizeWidget {
//   @override
//   final Size preferredSize;
//   final String title;
//   final String searchScope;
//   final String searchType;
//
//   CareshareAppBar(this.title, this.searchScope, this.searchType, {Key? key})
//       : preferredSize = const Size.fromHeight(50.0),
//         super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       leading: IconButton(
//         icon: Image.asset('images/CareShareLogo50.jpg'),
//         onPressed: () {
//           Navigator.of(context).pushNamed(HomePage.routeName);
//         },
//       ),
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title),
//           const BellWidget(),
//           if (searchType != "")
//             InkWell(
//               onTap: () {
//                 if (searchType == "Tasks") {
//                   Navigator.pushNamed(context, TaskSearch.routeName,
//                       arguments: searchScope);
//                 }
//               },
//               child: SizedBox(
//                 width: 50,
//                 height: 50,
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: const [
//                     Center(child: Icon(Icons.search)),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
