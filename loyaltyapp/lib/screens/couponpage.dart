import 'package:flutter/material.dart';
import 'package:loyaltyapp/network/api_handler.dart';
import 'package:loyaltyapp/components/company_rack.dart';
import 'package:loyaltyapp/data/globals.dart' as globals;
import 'package:loyaltyapp/network/api_handler.dart';

class CouponsPage extends StatefulWidget {
  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  List<String> categories = ["All"];
  Map<String, dynamic> groupedCompanyData = {};
  String selectedCategory = "All";

  final String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2MzBhNjlhNTg3ZWVjNDg3MWI3Mzk4NyIsImlhdCI6MTcxNDQ4MDI4NH0.9iVivjFzBB1CV_eGOD34apiS6zuLGHlVWaFjl50V5Nc';

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchLoyaltyCards();
  }

  void fetchCategories() async {
    try {
      final fetchedCategories = await ApiService.fetchCategories(token);
      setState(() {
        categories = ["All", ...fetchedCategories];
      });
    } catch (error) {
      print("Failed to fetch categories: $error");
    }
  }

  void fetchLoyaltyCards({String? category}) async {
    try {
      final fetchedLoyaltyCards =
          await ApiService.fetchLoyaltyCards(token, category: category);
      setState(() {
        groupedCompanyData = _groupByCompanyName(fetchedLoyaltyCards);
      });
    } catch (error) {
      print("Failed to fetch loyalty cards: $error");
    }
  }

  Map<String, dynamic> _groupByCompanyName(List<Map<String, dynamic>> data) {
    final Map<String, dynamic> groupedData = {};

    for (var item in data) {
      final companyName = item['brand'] ?? 'Unknown';
      final offer = {
        'id': item['_id'] ?? 'No ID',
        'token': token,
        'imageUrl': item['image'] ?? '',
        'description': item['description'] ?? 'No Description',
        'couponDetails': item['title'] ?? 'No Details',
      };
      print(offer);
      if (groupedData.containsKey(companyName)) {
        groupedData[companyName]['offers'].add(offer);
      } else {
        groupedData[companyName] = {
          'companyLogoUrl': item['brand_logo'] ?? '',
          'offers': [offer]
        };
      }
    }
    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Redeem Coupons"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: FilterChip(
                      label: Text(categories[index]),
                      selected: selectedCategory == categories[index],
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = categories[index];
                        });
                        fetchLoyaltyCards(
                            category: selectedCategory == "All"
                                ? null
                                : selectedCategory);
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: groupedCompanyData.length,
                itemBuilder: (context, index) {
                  final companyName = groupedCompanyData.keys.elementAt(index);
                  final data = groupedCompanyData[companyName];
                  final offers = (data['offers'] as List<dynamic>)
                      .map((offer) => Map<String, String>.from(offer))
                      .toList();

                  return CompanyRack(
                    companyName: companyName,
                    companyLogoUrl: data['companyLogoUrl'] ?? '',
                    offers: offers,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompanyRack extends StatelessWidget {
  final String companyName;
  final String companyLogoUrl;
  final List<Map<String, String>> offers;

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
                        offers[index],
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildOfferCard(offers[index]),
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

  void showOfferRedeemDialog(
      BuildContext context, Map<String, String> offer) async {
    final TextEditingController pinController = TextEditingController();
    const correctPin =
        '1234'; // This is a hardcoded correct PIN. Replace it with actual logic if needed.
    final offerdata =
        await ApiService.fetchLoyaltyCardData(offer['token']!, offer['id']!);
    print(offerdata);

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
                            pinController.text += value;
                            FocusScope.of(context).nextFocus();
                          }
                          if (value.length == 0) {
                            pinController.text = pinController.text
                                .substring(0, pinController.text.length - 1);
                            FocusScope.of(context).previousFocus();
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
                      "Expiry\n ${offerdata['data']['expiry']}",
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      "Worth of Voucher\n ${offerdata['data']['coin_worth']} AED",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Total coins cost\n${offerdata['data']['coin_cost']}",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Implement PIN validation logic here
                    // print(" pin text ${pinController.text}");
                    // print(pinController.text ==
                    //     offerdata['data']['OTP'].toString());
                    // print(offerdata['data']['OTP']);
                    final coin =
                        int.parse(offerdata['data']['coin_cost'].toString());
                    print(coin);
                    if (pinController.text ==
                        offerdata['data']['OTP'].toString()) {
                      if (globals.coins < coin) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Insufficient coins!"),
                        ));
                        return;
                      } else {
                        globals.coins -= coin;
                        print(globals.coins);
                        pinController.clear();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Offer redeemed successfully!"),
                        ));
                      }
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
