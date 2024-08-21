import 'package:flutter/material.dart';

class CompanyRack extends StatelessWidget {
  final String companyName;
  final String companyLogoUrl;
  final List<Map<String, dynamic>> offers;

  const CompanyRack({
    Key? key,
    required this.companyName,
    required this.companyLogoUrl,
    required this.offers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(companyLogoUrl),
                ),
                SizedBox(width: 10),
                Text(
                  companyName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 180, // Adjusted height for offers
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showOfferRedeemDialog(
                        context,
                        offers[index].cast<String, String>(),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          buildOfferCard(offers[index].cast<String, String>()),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOfferCard(Map<String, String> offer) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              offer['imageUrl']!,
              fit: BoxFit.cover,
              height: 80,
              width: double.infinity,
            ),
            SizedBox(height: 8),
            Text(
              offer['description']!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              offer['couponDetails']!,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showOfferRedeemDialog(BuildContext context, Map<String, String> offer) {
    final TextEditingController pinController = TextEditingController();
    const correctPin =
        '1234'; // This is a hardcoded correct PIN. Replace it with actual logic if needed.

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.all(8.0),
          content: Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150'), // Company logo URL
                      radius: 20,
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Offer Image
                Image.network(
                  offer['imageUrl']!,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10),
                // Description
                Text(
                  offer['description']!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                // Additional Information
                Text(
                  "Effortlessly expand your payment options",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 10),
                // Pin Input
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Container(
                      width: 40,
                      height: 40,
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        controller: TextEditingController(),
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: "",
                        ),
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
                SizedBox(height: 10),
                // Coupon Details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Expiry\n22 March 2024",
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      "Worth of Voucher\n342 AED",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Total coins cost\n400 Coins",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Implement PIN validation logic here
                    if (pinController.text == correctPin) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Offer redeemed successfully!"),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Invalid PIN. Please try again."),
                      ));
                    }
                  },
                  child: Text("Redeem Now"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class OffersList extends StatelessWidget {
  final List<Map<String, dynamic>> offersData;

  const OffersList({
    Key? key,
    required this.offersData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, dynamic>>> groupedOffers = {};

    for (var offer in offersData) {
      final companyName = offer['companyName'] as String;
      if (groupedOffers.containsKey(companyName)) {
        groupedOffers[companyName]!.add(offer);
      } else {
        groupedOffers[companyName] = [offer];
      }
    }

    return ListView(
      children: groupedOffers.entries.map((entry) {
        final companyName = entry.key;
        final offers = entry.value;
        final companyLogoUrl = offers[0]['companyLogoUrl'] as String;

        return CompanyRack(
          companyName: companyName,
          companyLogoUrl: companyLogoUrl,
          offers: offers,
        );
      }).toList(),
    );
  }
}


// import 'package:flutter/material.dart';

// class CompanyRack extends StatelessWidget {
//   final String companyName;
//   final String companyLogoUrl;
//   final String offerTitle;
//   final List<Map<String, String>> offers;

//   const CompanyRack({
//     Key? key,
//     required this.companyName,
//     required this.companyLogoUrl,
//     required this.offerTitle,
//     required this.offers,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       elevation: 3.0,
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 20,
//                   backgroundImage: NetworkImage(companyLogoUrl),
//                 ),
//                 SizedBox(width: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       companyName,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     Text(
//                       offerTitle,
//                       style: TextStyle(
//                         color: Colors.redAccent,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             SizedBox(
//               height: 200, // Adjusted height for stacked offers
//               child: ListView(
//                 children: offers.map((offer) => buildStackedOfferCard(offer)).toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildStackedOfferCard(Map<String, String> offer) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Stack(
//         children: [
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: 100,
//               decoration: BoxDecoration(
//                 color: Colors.amber.shade100,
//                 borderRadius: BorderRadius.circular(10.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 4.0,
//                     offset: Offset(2, 2),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Image.network(
//                       offer['imageUrl']!,
//                       fit: BoxFit.cover,
//                       height: 80,
//                       width: 80,
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             offer['description']!,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             offer['couponDetails']!,
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }














// import 'package:flutter/material.dart';

// class CouponsPage extends StatefulWidget {
//   @override
//   State<CouponsPage> createState() => _CouponsPageState();
// }

// class _CouponsPageState extends State<CouponsPage> {
//   final List<Map<String, dynamic>> companyData = [
//     {
//       'companyName': 'McDonald\'s',
//       'companyLogoUrl': 'https://via.placeholder.com/150',
//       'offerTitle': 'Ramadan New Offers',
//       'offers': [
//         {
//           'imageUrl': 'https://via.placeholder.com/100',
//           'description': 'Get a free burger on your next purchase.',
//           'couponDetails': 'Expiry: 22 March 2024',
//           'value': '342 AED',
//           'coinsCost': '400 Coins'
//         },
//         {
//           'imageUrl': 'https://via.placeholder.com/100',
//           'description': 'Buy one get one free on all fries.',
//           'couponDetails': 'Expiry: 30 April 2024',
//           'value': '150 AED',
//           'coinsCost': '300 Coins'
//         },
//       ]
//     },
//     {
//       'companyName': 'Starbucks',
//       'companyLogoUrl': 'https://via.placeholder.com/150',
//       'offerTitle': 'Coffee for Couples',
//       'offers': [
//         {
//           'imageUrl': 'https://via.placeholder.com/100',
//           'description': 'Free coffee with purchase of any cake.',
//           'couponDetails': 'Expiry: 15 April 2024',
//           'value': '50 AED',
//           'coinsCost': '200 Coins'
//         },
//         {
//           'imageUrl': 'https://via.placeholder.com/100',
//           'description': '20% off on all beverages.',
//           'couponDetails': 'Expiry: 22 March 2024',
//           'value': '100 AED',
//           'coinsCost': '250 Coins'
//         },
//       ]
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Redeem Coupons"),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ListView.builder(
//           itemCount: companyData.length,
//           itemBuilder: (context, index) {
//             final data = companyData[index];
//             return CompanyRack(
//               companyName: data['companyName'],
//               companyLogoUrl: data['companyLogoUrl'],
//               offerTitle: data['offerTitle'],
//               offers: List<Map<String, String>>.from(data['offers']),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class CompanyRack extends StatelessWidget {
//   final String companyName;
//   final String companyLogoUrl;
//   final String offerTitle;
//   final List<Map<String, String>> offers;

//   const CompanyRack({
//     Key? key,
//     required this.companyName,
//     required this.companyLogoUrl,
//     required this.offerTitle,
//     required this.offers,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       elevation: 3.0,
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 20,
//                   backgroundImage: NetworkImage(companyLogoUrl),
//                 ),
//                 SizedBox(width: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       companyName,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     Text(
//                       offerTitle,
//                       style: TextStyle(
//                         color: Colors.redAccent,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             SizedBox(
//               height: 220, // Adjust height to accommodate stacked cards
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: offers.length,
//                 itemBuilder: (context, index) {
//                   return buildStackedOfferCard(offers[index]);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildStackedOfferCard(Map<String, String> offer) {
//     return Container(
//       width: 160,
//       margin: EdgeInsets.only(right: 10),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Positioned(
//             top: 30,
//             child: Container(
//               width: 140,
//               decoration: BoxDecoration(
//                 color: Colors.amber.shade100,
//                 borderRadius: BorderRadius.circular(10.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 4.0,
//                     offset: Offset(2, 2),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 70), // Adjusted space for image
//                     Text(
//                       offer['description']!,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       offer['couponDetails']!,
//                       style: TextStyle(
//                         fontSize: 10,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       offer['value']!,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       offer['coinsCost']!,
//                       style: TextStyle(
//                         fontSize: 10,
//                         color: Colors.black54,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: -20,
//             left: 10,
//             right: 10,
//             child: CircleAvatar(
//               radius: 40,
//               backgroundImage: NetworkImage(offer['imageUrl']!),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
