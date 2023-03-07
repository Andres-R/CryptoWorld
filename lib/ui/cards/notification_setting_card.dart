import 'package:crypto_world/utils/constants.dart';
import 'package:flutter/material.dart';

class NotificationSettingCard extends StatelessWidget {
  const NotificationSettingCard({
    Key? key,
    required this.name,
    required this.criteria,
    required this.percent,
  }) : super(key: key);

  final String name;
  final String criteria;
  final double percent;

  @override
  Widget build(BuildContext context) {
    Color determineColor = criteria == 'up' ? Colors.green : Colors.red;

    return Padding(
      padding: EdgeInsets.all(kPadding),
      child: SizedBox(
        //height: 100,
        //color: Colors.black,
        child: Row(
          children: [
            Container(
              height: 25,
              width: 25,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.check,
                  color: kTextColor,
                ),
              ),
            ),
            SizedBox(width: kPadding),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: 'Send a notification for $name when the price '
                      'in the past 24h is ',
                  children: [
                    TextSpan(
                      text: '$criteria $percent%',
                      style: TextStyle(
                        color: determineColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// class NotificationSettingCard extends StatelessWidget {
//   const NotificationSettingCard({
//     Key? key,
//     required this.name,
//     required this.criteria,
//     required this.percent,
//   }) : super(key: key);

//   final String name;
//   final String criteria;
//   final double percent;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: SizedBox(
//         //height: 100,
//         //color: Colors.black,
//         child: Padding(
//           padding: const EdgeInsets.all(0.0),
//           child: Row(
//             children: [
//               Container(
//                 height: 25,
//                 width: 25,
//                 decoration: const BoxDecoration(
//                   color: Colors.green,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Center(
//                   child: Icon(
//                     Icons.check,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Text(
//                   'Send a notification for $name when the price '
//                   'in the past 24h is $criteria $percent%',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
