// import 'package:flutter/material.dart';

// class ProgressDialog extends StatelessWidget {
//   String? message;

//   ProgressDialog({super.key, this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.black54,
//       child: Container(
//         margin: const EdgeInsets.all(16.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: Row(
//           children: [
//             const SizedBox(
//               width: 8,
//             ),
//             const CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
//             ),
//             const SizedBox(
//               width: 20,
//             ),
//             Text(
//               message!,
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontSize: 12,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
