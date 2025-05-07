// import 'package:Cesta/component/containersLoading.dart';
// import 'package:Cesta/component/widgets/itemcontainer.dart';
// import 'package:Cesta/view/careers/home/homepage.dart';
// import 'package:Cesta/view/club/home/homepage.dart';
// import 'package:Cesta/view/home/account/adddependents/adddependentsscreen.dart';
// import 'package:Cesta/view/seller/homepage/sellerhp.dart';
// import 'package:Cesta/view/vacancies/home/homepage.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';

// import '../../../services/home/homepage.dart';

// class PlanCarousel extends StatelessWidget {
//   final int planId;

//   const PlanCarousel({Key? key, required this.planId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     switch (planId) {
//       case 5: // Plano Free
//         return CarouselSlider(
//           items: [
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HomePageClub(),
//                   ),
//                 );
//               },
//               title: "Club",
//               desc:
//                   "Cashbacks e descontos em compras em lojas de todo o Brasil!",
//             ),
//           ],
//           options: CarouselOptions(
//             height: 450,
//             autoPlay: true,
//             autoPlayInterval: const Duration(seconds: 3),
//             enlargeCenterPage: true,
//             viewportFraction: 0.8,
//           ),
//         );
//       case 2: // Plano Essencial
//         return CarouselSlider(
//           items: [
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HomePageClub(),
//                   ),
//                 );
//               },
//               title: "Club",
//               desc:
//                   "Cashbacks e descontos em compras em lojas de todo o Brasil!",
//             ),
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HomePageServices(),
//                   ),
//                 );
//               },
//               title: "Serviços",
//               desc: "Todos os serviços que precisa em um só lugar!",
//             ),
//           ],
//           options: CarouselOptions(
//             height: 450,
//             autoPlay: true,
//             autoPlayInterval: const Duration(seconds: 3),
//             enlargeCenterPage: true,
//             viewportFraction: 0.8,
//           ),
//         );
//       case 3: // Plano Enterprise
//         return CarouselSlider(
//           items: [
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HomePageClub(),
//                   ),
//                 );
//               },
//               title: "Club",
//               desc:
//                   "Cashbacks e descontos em compras em lojas de todo o Brasil!",
//             ),
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HomePageServices(),
//                   ),
//                 );
//               },
//               title: "Serviços",
//               desc: "Todos os serviços que precisa em um só lugar!",
//             ),
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CoursesHomePage(),
//                   ),
//                 );
//               },
//               title: "Cursos",
//               desc: "Cursos exclusivos pra você",
//             ),
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HomePageVacancies(),
//                   ),
//                 );
//               },
//               title: "Vagas",
//               desc: "Vagas de emprego pra você!",
//             ),
//           ],
//           options: CarouselOptions(
//             height: 450,
//             autoPlay: true,
//             autoPlayInterval: const Duration(seconds: 3),
//             enlargeCenterPage: true,
//             viewportFraction: 0.8,
//           ),
//         );
//       case 4: // Plano Study
//         return CarouselSlider(
//           items: [
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HomePageClub(),
//                   ),
//                 );
//               },
//               title: "Club",
//               desc:
//                   "Cashbacks e descontos em compras em lojas de todo o Brasil!",
//             ),
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HomePageServices(),
//                   ),
//                 );
//               },
//               title: "Serviços",
//               desc: "Todos os serviços que precisa em um só lugar!",
//             ),
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CoursesHomePage(),
//                   ),
//                 );
//               },
//               title: "Cursos",
//               desc: "Cursos exclusivos pra você",
//             ),
//           ],
//           options: CarouselOptions(
//             height: 450,
//             autoPlay: true,
//             autoPlayInterval: const Duration(seconds: 3),
//             enlargeCenterPage: true,
//             viewportFraction: 0.8,
//           ),
//         );
//       case 6: // Plano Black
//         return CarouselSlider(
//           items: [
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HomePageClub(),
//                   ),
//                 );
//               },
//               title: "Club",
//               desc:
//                   "Cashbacks e descontos em compras em lojas de todo o Brasil!",
//             ),
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HomePageServices(),
//                   ),
//                 );
//               },
//               title: "Serviços",
//               desc: "Todos os serviços que precisa em um só lugar!",
//             ),
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CoursesHomePage(),
//                   ),
//                 );
//               },
//               title: "Cursos",
//               desc: "Cursos exclusivos pra você",
//             ),
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HomePageVacancies(),
//                   ),
//                 );
//               },
//               title: "Vagas",
//               desc: "Vagas de emprego pra você!",
//             ),
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SellerHp(),
//                   ),
//                 );
//               },
//               title: "Adicionar Loja Local",
//               desc: "Adicionar loja local para começar a vender!",
//             ),
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AddDependentsScreen(),
//                   ),
//                 );
//               },
//               title: "Adicionar Dependentes",
//               desc:
//                   "Adicionar Dependentes para compartilhar seus beneficios com ela.",
//             ),
//           ],
//           options: CarouselOptions(
//             height: 450,
//             autoPlay: true,
//             autoPlayInterval: const Duration(seconds: 3),
//             enlargeCenterPage: true,
//             viewportFraction: 0.8,
//           ),
//         );
//       case 7: // Plano Depedente
//         return CarouselSlider(
//           items: [
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HomePageClub(),
//                   ),
//                 );
//               },
//               title: "Club",
//               desc:
//                   "Cashbacks e descontos em compras em lojas de todo o Brasil!",
//             ),
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HomePageServices(),
//                   ),
//                 );
//               },
//               title: "Serviços",
//               desc: "Todos os serviços que precisa em um só lugar!",
//             ),
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CoursesHomePage(),
//                   ),
//                 );
//               },
//               title: "Cursos",
//               desc: "Cursos exclusivos pra você",
//             ),
//             ItemContainer(
//               onClick: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HomePageVacancies(),
//                   ),
//                 );
//               },
//               title: "Vagas",
//               desc: "Vagas de emprego pra você!",
//             ),
//           ],
//           options: CarouselOptions(
//             height: 450,
//             autoPlay: true,
//             autoPlayInterval: const Duration(seconds: 3),
//             enlargeCenterPage: true,
//             viewportFraction: 0.8,
//           ),
//         );
//       default:
//         return SizedBox(
//             height: 300,
//             child: Center(
//               child:
//                   ErrorPost(text: "Esse plano está indisponpivel no momento."),
//             )); // Retorna um widget vazio se o planId não for reconhecido
//     }
//   }
// }
