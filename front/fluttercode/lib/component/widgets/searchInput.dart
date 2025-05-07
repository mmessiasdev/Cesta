// import 'package:Cesta/component/colors.dart';
// import 'package:flutter/material.dart';

// class SearchClubInput extends StatelessWidget {
//   SearchClubInput({super.key, required this.isClickable});

//   bool isClickable;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: GestureDetector(
//         child: Container(
//           width: double.infinity,
//           height: 45,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             color: SixthColor,
//           ),
//           child: const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//             child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Icon(
//                   Icons.search,
//                   size: 25,
//                 )),
//           ),
//         ),
//         onTap: () {
//           showSearch(
//             context: context,
//             delegate: SearchDelegateScreen(
//               isClickable: isClickable,
//             ), // Chamando o SearchDelegate
//           );
//         },
//       ),
//     );
//   }
// }

// class SearchCoursesInput extends StatelessWidget {
//   const SearchCoursesInput({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: GestureDetector(
//         child: Container(
//           width: double.infinity,
//           height: 45,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             color: SixthColor,
//           ),
//           child: const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//             child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Icon(
//                   Icons.search,
//                   size: 25,
//                 )),
//           ),
//         ),
//         onTap: () {
//           showSearch(
//             context: context,
//             delegate:
//                 SearchCoursesDelegateScreen(), // Chamando o SearchDelegate
//           );
//         },
//       ),
//     );
//   }
// }

// class SearchDepedentsInput extends StatelessWidget {
//   const SearchDepedentsInput({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: GestureDetector(
//         child: Container(
//           width: double.infinity,
//           height: 45,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: PrimaryColor,
//           ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//             child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Icon(
//                   Icons.search,
//                   size: 25,
//                   color: lightColor,
//                 )),
//           ),
//         ),
//         onTap: () {
//           showSearch(
//             context: context,
//             useRootNavigator: true,
//             delegate:
//                 SearchDependentDelegateScreen(), // Chamando o SearchDelegate
//           );
//         },
//       ),
//     );
//   }
// }
