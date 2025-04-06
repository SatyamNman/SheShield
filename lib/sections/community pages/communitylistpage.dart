// import 'package:flutter/material.dart';
// import 'community.dart';

// class CommunityListPage extends StatelessWidget {
//    CommunityListPage({super.key});

//   final List<Map<String, String>> communities = [
//     {
//       "title": "AI & Machine Learning",
//       "description": "Discuss AI trends, ML models, and data science.",
//       "members": "12K Members",
//       "image":
//           "https://img.freepik.com/free-vector/data-scientists-teamwork-illustration_52683-44600.jpg"
//     },
//     {
//       "title": "Blockchain Developers",
//       "description": "Explore blockchain, crypto, and smart contracts.",
//       "members": "8K Members",
//       "image":
//           "https://img.freepik.com/free-vector/blockchain-technology-concept-illustration_114360-4635.jpg"
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text("Communities"),
//         backgroundColor: Colors.black,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: communities.length,
//         itemBuilder: (context, index) {
//           final community = communities[index];

//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => CommunityDetailsPage(
//                     title: community["title"]!,
//                     description: community["description"]!,
//                     members: community["members"]!,
//                     imageUrl: community["image"]!,
//                   ),
//                 ),
//               );
//             },
//             child: Container(
//               margin: const EdgeInsets.only(bottom: 16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[900],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ClipRRect(
//                     borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(12),
//                         topRight: Radius.circular(12)),
//                     child: Image.network(
//                       community["image"]!,
//                       height: 150,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           community["title"]!,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           community["description"]!,
//                           style: TextStyle(color: Colors.grey[400]),
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             const Icon(Icons.people, color: Colors.pink, size: 18),
//                             const SizedBox(width: 5),
//                             Text(
//                               community["members"]!,
//                               style: TextStyle(color: Colors.grey[400]),
//                             ),
//                             const Spacer(),
//                             ElevatedButton(
//                               onPressed: () {},
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.pink,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               child: const Text(
//                                 "Join",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
