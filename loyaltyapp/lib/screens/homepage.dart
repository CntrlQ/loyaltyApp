import 'package:loyaltyapp/components/card.dart';
import 'package:loyaltyapp/screens/couponpage.dart';
import 'package:flutter/material.dart';
import 'package:loyaltyapp/data/globals.dart' as globals;

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return homepagestate();
  }
}

class homepagestate extends State<Homepage> {
  int coins = globals.coins;

  @override
  void didUpdateWidget(covariant Homepage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (coins != globals.coins) {
      setState(() {
        coins = globals.coins;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(globals.coins);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 0, 77, 141), Color(0xFF025F9E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.55,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Reward",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "$coins Coins",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color(0xFF0373CF),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                        ),
                        child: Text(
                          "Redeem Now",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.grey[200],
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Redeemed Coupons",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          child: Text(
                            "View all",
                            style: TextStyle(
                              color: Color(0xFF0373CF),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CouponsPage()),
                            ).then((_) {
                              // Ensure coins are updated after returning from CouponsPage
                              setState(() {
                                coins = globals.coins;
                              });
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        card(),
                        card(),
                        card(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
