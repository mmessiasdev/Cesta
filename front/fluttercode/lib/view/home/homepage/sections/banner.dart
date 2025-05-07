// import 'package:Cesta/component/bannerlist.dart';
// import 'package:Cesta/component/colors.dart';
// import 'package:Cesta/component/containersLoading.dart';
// import 'package:Cesta/service/remote/account/crud.dart';
// import 'package:Cesta/service/remote/auth.dart';
// import 'package:carousel_slider/carousel_options.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';

// import '../../../../model/carrouselbanner.dart';

// class PreferidosSection extends StatelessWidget {
//   final String? token;
//   final String? profileId;

//   const PreferidosSection(
//       {Key? key, required this.token, required this.profileId})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       bool isDesktop = constraints.maxWidth > 800;

//       return FutureBuilder<Map>(
//         future:
//             AccountService().getProfile(id: profileId.toString(), token: token),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             if (snapshot.hasData) {
//               var profile = snapshot.data! as Map<String, dynamic>;
//               return FutureBuilder<List<Banners>>(                future: RemoteAuthService()
//                     .getCarrouselBanners(token: token, id: "1"),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.done &&
//                       snapshot.hasData) {
//                     if (snapshot.data!.isEmpty) {
//                       return const SizedBox(
//                           height: 50, child: Center(child: SizedBox()));
//                     } else {
//                       return CarouselSlider.builder(
//                         itemCount: snapshot.data!.length,
//                         itemBuilder: (context, index, realIndex) {
//                           var renders = snapshot.data![index];
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 15),
//                             child: BannerList(
//                               imageUrl: renders.urlimage.toString(),
//                               isInternalRedirect: false,
//                               redirectUrl: renders.urlroute.toString(),
//                             ),
//                           );
//                         },
//                         options: CarouselOptions(
//                           height: isDesktop ? 280 : 150,
//                           autoPlay: true,
//                           autoPlayInterval: const Duration(seconds: 3),
//                           enlargeCenterPage: true,
//                           viewportFraction: 0.8,
//                         ),
//                       );
//                     }
//                   } else if (snapshot.hasError) {
//                     return const Center(child: SizedBox());
//                   }
//                   return SizedBox(
//                     height: 150,
//                     child: const Center(child: CircularProgressIndicator()),
//                   );
//                 },
//               );
//             } else if (snapshot.hasError) {
//               return SizedBox(
//                 height: 280,
//                 child: Padding(
//                   padding: EdgeInsets.all(10),
//                   child: ErrorPost(
//                     text:
//                         "Estamos passando por uma manutenção. Volte em breve!",
//                   ),
//                 ),
//               );
//             }
//           }
//           return SizedBox(
//             height: 300,
//             child: Center(
//               child: CircularProgressIndicator(color: PrimaryColor),
//             ),
//           );
//         },
//       );
//     });
//   }
// }
