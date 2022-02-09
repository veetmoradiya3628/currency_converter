import 'package:google_fonts/google_fonts.dart';

import 'services/api_client.dart';
import 'package:currency_converter/drop_down.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Instance of API Client
  ApiClient client = ApiClient();

  // Function to call API

  @override
  void initState() {
    super.initState();
    (() async {
      List<String> list = await client.getCurrencies();
      setState(() {
        currencies = list;
      });
    })();
  }

  // Setting main colors
  Color kMainColor = const Color(0xFF212936);
  Color kSecondaryColor = Colors.black;

  //Setting the variables
  List<String> currencies = ["INR", "USD"];
  String from = "INR";
  String to = "USD";

  //variables for exchange rate
  double rate = 1;
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/money.jpg'),
              fit: BoxFit.cover
            ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 55.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  child: Text(
                    "Currency Converter",
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          letterSpacing: .5,
                          fontSize: 40,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextField(
                          onChanged: (value) async {
                            rate = await client.getRate(from, to);
                            setState(() {
                              result =
                                  (rate * double.parse(value)).toStringAsFixed(3);
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)
                            ),
                            prefixIcon: const Icon(
                                Icons.attach_money_sharp,
                              color: Colors.black,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          style: GoogleFonts.lato(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customDropDown(currencies, from, (val) {
                              setState(() {
                                from = val;
                              });
                            }),
                            FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  String temp = from;
                                  from = to;
                                  to = temp;
                                });
                              },
                              child: const Icon(Icons.swap_horiz),
                              elevation: 0.0,
                              backgroundColor: Colors.black,
                            ),
                            customDropDown(currencies, to, (val) {
                              setState(() {
                                to = val;
                              });
                            }),
                          ],
                        ),
                        const SizedBox(height: 50.0),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            children: [
                              Text(
                                result,
                                style: GoogleFonts.lato(
                                  color: kMainColor,
                                  fontSize: 36.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}