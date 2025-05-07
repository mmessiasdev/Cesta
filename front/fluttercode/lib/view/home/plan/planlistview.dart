// import 'package:Cesta/view/home/homepage/plan/plancarroulsel.dart';
// import 'package:flutter/material.dart';

// class PlanListView extends StatelessWidget {
//   final Map<String, dynamic> profile;

//   const PlanListView({Key? key, required this.profile}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: 1, // Ajuste o itemCount conforme necessário
//       itemBuilder: (context, index) {
//         return SizedBox(
//           child: Center(
//             child: Column(
//               children: [
//                 if (profile["plan"]["id"] != null) ...[
//                   PlanCarousel(planId: profile["plan"]["id"]),
//                 ],
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }