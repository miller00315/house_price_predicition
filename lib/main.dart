import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
//-121.56	39.27	28	2332	395.0	1041	344	3.7125	0	1	0	0	0
// 4087 rows × 13 columns
class _MyHomePageState extends State<MyHomePage> {
  late Interpreter interpreter;
  var result = "House Price";
  var mean = [
    -119.564154,
    35.630318,
    28.664505,
    2622.235776,
    535.281659,
    1416.087055,
    496.758167,
    3.869337,
    0.441454,
    0.319405,
    0.000306,
    0.109874,
    0.128961
  ];
  var std = [
    2.002618,
    2.138574,
    12.556764,
    2169.548287,
    418.469078,
    1103.842065,
    379.109535,
    1.902228,
    0.496576,
    0.466261,
    0.017487,
    0.312742,
    0.335167
  ];
  @override
  void initState() {
    super.initState();
    loadModel();
  }

  loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/house_prediction.tflite');
  }

  performAction() {
    double lat = double.parse(latController.text);
    double log = double.parse(logController.text);
    double age = double.parse(ageController.text);
    double rooms = double.parse(roomsController.text);
    double bedrooms = double.parse(bedroomsController.text);
    double population = double.parse(populationController.text);
    double household = double.parse(householdController.text);
    double income = double.parse(incomeController.text);
    double oceanA = 1;
    double oceanB = 0;
    double oceanC = 0;
    double oceanD = 0;
    double oceanE = 0;

    if (oceanValue == "<1H OCEAN") {
      oceanA = 1;
      oceanB = 0;
      oceanC = 0;
      oceanD = 0;
      oceanE = 0;
    } else if (oceanValue == "INLAND") {
      oceanA = 0;
      oceanB = 1;
      oceanC = 0;
      oceanD = 0;
      oceanE = 0;
    } else if (oceanValue == "ISLAND") {
      oceanA = 0;
      oceanB = 0;
      oceanC = 1;
      oceanD = 0;
      oceanE = 0;
    } else if (oceanValue == "NEAR BAY") {
      oceanA = 0;
      oceanB = 0;
      oceanC = 0;
      oceanD = 1;
      oceanE = 0;
    } else if (oceanValue == "NEAR OCEAN") {
      oceanA = 0;
      oceanB = 0;
      oceanC = 0;
      oceanD = 0;
      oceanE = 1;
    }

    lat = (lat - mean[0]) / std[0];
    log = (log - mean[1]) / std[1];
    age = (age - mean[2]) / std[2];
    rooms = (rooms - mean[3]) / std[3];
    bedrooms = (bedrooms - mean[4]) / std[4];
    population = (population - mean[5]) / std[5];
    household = (household - mean[6]) / std[6];
    income = (income - mean[7]) / std[7];
    oceanA = (oceanA - mean[8]) / std[8];
    oceanB = (oceanB - mean[9]) / std[9];
    oceanC = (oceanC - mean[10]) / std[10];
    oceanD = (oceanD - mean[11]) / std[11];
    oceanE = (oceanE - mean[12]) / std[12];
    // For ex: if input tensor shape [1,5] and type is float32
    var input = [
      lat,
      log,
      age,
      rooms,
      bedrooms,
      population,
      household,
      income,
      oceanA,
      oceanB,
      oceanC,oceanD,oceanE
    ];

    // if output tensor shape [1,1] and type is float32
    var output = List.filled(1, 0).reshape([1, 1]);

    // inference
    interpreter.run(input, output);

    // print the output
    setState(() {
      result = output[0][0].toStringAsFixed(2);
    });
  }

  TextEditingController latController = TextEditingController();
  TextEditingController logController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController roomsController = TextEditingController();
  TextEditingController bedroomsController = TextEditingController();
  TextEditingController populationController = TextEditingController();
  TextEditingController householdController = TextEditingController();
  TextEditingController incomeController = TextEditingController();
  String oceanValue = 'NEAR BAY';
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: SingleChildScrollView(
          controller: scrollController,
          child: SizedBox(
            // margin: EdgeInsets.only(left: 40,right: 40),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 350,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 10),
                        child: Image.asset(
                          'assets/icon.png',
                          width: 150,
                          height: 150,
                        ),
                      ),
                      Text(
                        result,
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 150,
                  color: Colors.brown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 50, right: 50),
                        child: Image.asset(
                          'assets/icon.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: latController,
                          decoration: const InputDecoration(
                              hintText: 'Latitude',
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 150,
                  color: Colors.grey,
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: logController,
                          decoration: const InputDecoration(
                              hintText: 'Longitude',
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 50, right: 50),
                        child: Image.asset(
                          'assets/icon.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 150,
                  color: Colors.blueGrey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 50, right: 50),
                        child: Image.asset(
                          'assets/icon.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: ageController,
                          decoration: const InputDecoration(
                              hintText: 'Total Age',
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 150,
                  color: Colors.deepPurple,
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: roomsController,
                          decoration: const InputDecoration(
                              hintText: 'Total Rooms',
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 50, right: 50),
                        child: Image.asset(
                          'assets/icon.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 150,
                  color: Colors.orange,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 50, right: 50),
                        child: Image.asset(
                          'assets/icon.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: bedroomsController,
                          decoration: const InputDecoration(
                              hintText: 'Bedrooms',
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 150,
                  color: Colors.lime,
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: populationController,
                          decoration: const InputDecoration(
                              hintText: 'Population',
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 50, right: 50),
                        child: Image.asset(
                          'assets/icon.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 150,
                  color: Colors.deepOrange,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 50, right: 50),
                        child: Image.asset(
                          'assets/icon.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: householdController,
                          decoration: const InputDecoration(
                              hintText: 'Household',
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 150,
                  color: Colors.greenAccent,
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: incomeController,
                          decoration: const InputDecoration(
                              hintText: 'Income',
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 50, right: 50),
                        child: Image.asset(
                          'assets/icon.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 150,
                  color: Colors.brown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 50, right: 50),
                        child: Image.asset(
                          'assets/icon.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      DropdownButton(
                          // Initial Value
                          value: oceanValue,
                          // Down Arrow Icon
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),

                          // Array list of items
                          items: [
                            '<1H OCEAN',
                            'INLAND',
                            'NEAR OCEAN',
                            'NEAR BAY',
                            'ISLAND'
                          ].map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items,
                                style: const TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              oceanValue = newValue!;
                            });
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      scrollController.jumpTo(0);
                      performAction();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: const Text(
                      'Get',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
