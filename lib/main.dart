import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:houseagent/chat.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'House Agent',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _bedrooms = 3;
  int _bathrooms = 1;
  int _livingArea = 1180;
  int _lotArea = 5650;
  double _floors = 1;
  bool _waterfront = false;
  int _views = 0;
  int _condition = 3;
  int _grade = 7;
  int _aboveArea = 1180;
  int _basementArea = 0;
  int _yearBuilt = 1955;
  int _yearRenovated = 1900;
  double _latitude = 47.5112;
  double _longitude = -122.257;
  bool _isLoading = false;

  final List<String> conditions = [
    'Distressed',
    'Poor',
    'Fair',
    'Good',
    'Excellent'
  ];
  final List<String> _grades = [
    'Luxury',
    'High-End',
    'Premium',
    'Excellent',
    'Good',
    'Average',
    'Fair',
    'Subpar',
    'Renovation',
    'Poor',
    'Dilapidated',
    'Uninhabitable',
    'Ruined',
  ];
  double _price = 205590;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 10), () {});
    super.initState();
  }

  void runModel() async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(
      Uri.parse('https://goldendovah.pythonanywhere.com/ann'),
      //Uri.parse('http://127.0.0.1:5000/ann'),   Local host
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'bedrooms': _bedrooms,
        'bathrooms': _bathrooms,
        'sqft_living': _livingArea,
        'sqft_lot': _lotArea,
        'floors': _floors,
        'waterfront': _waterfront,
        'view': _views,
        'condition': _condition,
        'grade': _grade,
        'sqft_above': _aboveArea,
        'sqft_basement': _basementArea,
        'yr_built': _yearBuilt,
        'yr_renovated': _yearRenovated == 1900 ? 0.0 : _yearRenovated as double,
        'lat': _latitude,
        'long': _longitude,
        'sqft_living15': _livingArea,
        'sqft_lot15': _lotArea
      }),
    );
    Map<String, dynamic> responseData = json.decode(response.body);
    setState(() {
      _isLoading = false;
      _price = responseData['price'].toInt().toDouble();
    });
  }

  Future getData(url) async {
    http.Response response = await http.get(url);
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            MyApp.currentPageIndex = index;
          });
        },
        selectedIndex: MyApp.currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Measure',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: AnimatedSwitcher(
        duration: Duration(seconds: 1),
        child: <Widget>[
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: AnimatedContainer(
                        color: const Color.fromARGB(255, 126, 38, 142),
                        duration: const Duration(milliseconds: 500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Icon(
                                    _views == 0
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    '$_views',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                ),
                              ],
                            )),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Flexible(
                                    child: Icon(
                                      Icons.architecture,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                  ),
                                  Flexible(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          _condition,
                                          (index) => const Flexible(
                                            child: Icon(
                                              Icons.star,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: const Icon(
                                      Icons.attach_money_outlined,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                  ),
                                  Flexible(
                                    child: _isLoading
                                        ? CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text(
                                            '$_price\$',
                                            style: const TextStyle(
                                                fontSize: 30,
                                                color: Colors.white),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Flexible(
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                  ),
                                  Flexible(
                                      child: SizedBox(
                                    height: 30,
                                    width: 170,
                                    child: Center(
                                      child: Text(
                                        _grades.reversed.elementAt(_grade - 1),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 25),
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Flexible(
                                    child: Icon(
                                      Icons.map,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'lat: ${_latitude.toStringAsFixed(4)}',
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'long: ${_longitude.toStringAsFixed(4)}',
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(100.0),
                            child: Opacity(
                              opacity: 0.0,
                              child: Image.asset(
                                'assets/background.png',
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                          Center(
                            child: LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                double maxWidth = constraints.maxWidth;

                                double minLotArea = 500;
                                double maxLotArea = 1.7e+06;
                                double minSize = 500.0;
                                double maxSize = (maxWidth - 200)
                                    .clamp(100.0, double.infinity);

                                double normalizedLotArea =
                                    (_lotArea - minLotArea) /
                                        (maxLotArea - minLotArea);
                                double? widthLotArea = lerpDouble(
                                    minSize, maxSize, normalizedLotArea);
                                double heightLotArea = widthLotArea! - 200;
                                // Lot Area Container
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  color: Colors.green,
                                  width: widthLotArea,
                                  height: heightLotArea,
                                  child: Stack(
                                    children: [
                                      // Living Area Container
                                      Align(
                                        alignment: Alignment.center,
                                        child: LayoutBuilder(builder:
                                            (BuildContext context,
                                                BoxConstraints constraints) {
                                          double maxWidth =
                                              constraints.maxWidth;

                                          double minLivingArea = 200;
                                          double maxLivingArea = 14000;
                                          double minSize = 400.0;
                                          double maxSize = (maxWidth - 200)
                                              .clamp(100.0, double.infinity);

                                          double normalizedLivingArea =
                                              (_livingArea - minLivingArea) /
                                                  (maxLivingArea -
                                                      minLivingArea);
                                          double? widthLivingArea = lerpDouble(
                                              minSize,
                                              maxSize,
                                              normalizedLivingArea);
                                          double heightLivingArea =
                                              widthLivingArea! - 200;
                                          return AnimatedContainer(
                                            color: Colors.blue,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            width: widthLivingArea,
                                            height: heightLivingArea,
                                            child: Stack(
                                              children: [
                                                const Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Icon(
                                                    Icons.living,
                                                    color: Colors.white,
                                                    size: 60,
                                                  ),
                                                ),
                                                if (_floors > 1)
                                                  const Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Icon(
                                                      Icons.stairs,
                                                      color: Colors.white,
                                                      size: 60,
                                                    ),
                                                  ),
                                                if (_floors > 2)
                                                  const Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Icon(
                                                      Icons.stairs,
                                                      color: Colors.white,
                                                      size: 60,
                                                    ),
                                                  ),
                                                if (_floors > 3)
                                                  const Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Icon(
                                                      Icons.stairs,
                                                      color: Colors.white,
                                                      size: 60,
                                                    ),
                                                  ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: List.generate(
                                                          _bedrooms,
                                                          (index) =>
                                                              const Flexible(
                                                            child: Icon(
                                                              Icons
                                                                  .bedroom_parent,
                                                              color:
                                                                  Colors.white,
                                                              size: 50,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: List.generate(
                                                          _bathrooms,
                                                          (index) =>
                                                              const Flexible(
                                                            child: Icon(
                                                              Icons.bathroom,
                                                              color:
                                                                  Colors.white,
                                                              size: 50,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                      const Align(
                                        alignment: Alignment.bottomRight,
                                        child: Icon(
                                          Icons.yard,
                                          color: Colors.white,
                                          size: 60,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          if (_waterfront)
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Image.asset(
                                'assets/sandy.png',
                                fit: BoxFit.contain,
                                width: 150,
                                height: 150,
                              ),
                            ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const Flexible(
                                          child: Icon(
                                            Icons.arrow_upward,
                                            size: 60,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            '$_aboveArea sqft',
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const Flexible(
                                          child: Icon(
                                            Icons.arrow_downward,
                                            size: 60,
                                          ),
                                        ),
                                        Flexible(
                                            child: Text(
                                          '$_basementArea sqft',
                                          style: const TextStyle(fontSize: 20),
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const Flexible(
                                          child: Icon(
                                            Icons.calendar_month,
                                            size: 60,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            _yearBuilt.toString(),
                                            style:
                                                const TextStyle(fontSize: 25),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const Flexible(
                                          child: Icon(
                                            Icons.home_repair_service,
                                            size: 60,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            _yearRenovated == 1900
                                                ? 'None'
                                                : _yearRenovated.toString(),
                                            style:
                                                const TextStyle(fontSize: 25),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.purple,
                  child: LayoutBuilder(
                    builder: (context, constraint) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraint.maxHeight),
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 60.0),
                                    child: Icon(
                                      Icons.house,
                                      size: 100,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                // Bedrooms
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: const [
                                            Flexible(
                                              child: Icon(
                                                Icons.bedroom_parent,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Bedrooms",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: SleekCircularSlider(
                                          min: 0,
                                          max: 35,
                                          initialValue: _bedrooms as double,
                                          appearance: CircularSliderAppearance(
                                              infoProperties: InfoProperties(
                                                mainLabelStyle: const TextStyle(
                                                    color: Colors.white),
                                                modifier: (value) {
                                                  _bedrooms =
                                                      value.ceil().toInt();
                                                  return _bedrooms.toString();
                                                },
                                              ),
                                              size: 90),
                                          onChange: (double value) {
                                            Future.delayed(Duration.zero, () {
                                              setState(() {
                                                _bedrooms =
                                                    value.ceil().toInt();
                                              });
                                            });
                                          },
                                          onChangeEnd: (value) {
                                            runModel();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Bathrooms
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: const [
                                            Flexible(
                                              child: Icon(
                                                Icons.bathroom,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Bathrooms",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: SleekCircularSlider(
                                          min: 0,
                                          max: 9,
                                          initialValue: _bathrooms as double,
                                          appearance: CircularSliderAppearance(
                                              infoProperties: InfoProperties(
                                                mainLabelStyle: const TextStyle(
                                                    color: Colors.white),
                                                modifier: (value) {
                                                  _bathrooms.ceil().toInt();
                                                  return _bathrooms.toString();
                                                },
                                              ),
                                              size: 90),
                                          onChange: (double value) {
                                            Future.delayed(Duration.zero, () {
                                              setState(() {
                                                _bathrooms =
                                                    value.ceil().toInt();
                                              });
                                            });
                                          },
                                          onChangeEnd: (value) {
                                            runModel();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Living Area
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: const [
                                            Flexible(
                                              child: Icon(
                                                Icons.living,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Living Area",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: SleekCircularSlider(
                                          min: 200,
                                          max: 14000,
                                          initialValue: _livingArea as double,
                                          appearance: CircularSliderAppearance(
                                              infoProperties: InfoProperties(
                                                mainLabelStyle: const TextStyle(
                                                    color: Colors.white),
                                                modifier: (value) {
                                                  if (value < _lotArea) {
                                                    _livingArea =
                                                        value.ceil().toInt();
                                                  }
                                                  return '$_livingArea sqft';
                                                },
                                              ),
                                              size: 90),
                                          onChangeEnd: (double value) {
                                            if (value < _lotArea) {
                                              Future.delayed(Duration.zero, () {
                                                setState(() {
                                                  _livingArea =
                                                      value.ceil().toInt();
                                                });
                                                runModel();
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Lot Area
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: const [
                                            Flexible(
                                              child: Icon(
                                                Icons.yard,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Lot Area",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: SleekCircularSlider(
                                          min: 500,
                                          max: 1.7e+06,
                                          initialValue: _lotArea as double,
                                          appearance: CircularSliderAppearance(
                                              infoProperties: InfoProperties(
                                                mainLabelStyle: const TextStyle(
                                                    color: Colors.white),
                                                modifier: (value) {
                                                  _lotArea =
                                                      value.ceil().toInt();
                                                  return '$_lotArea sqft';
                                                },
                                              ),
                                              size: 110),
                                          onChangeEnd: (double value) {
                                            Future.delayed(Duration.zero, () {
                                              setState(() {
                                                _lotArea = value.ceil().toInt();
                                              });
                                              runModel();
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Floors
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: const [
                                            Flexible(
                                              child: Icon(
                                                Icons.stairs,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Floors",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: SleekCircularSlider(
                                          min: 1,
                                          max: 4,
                                          initialValue: _floors,
                                          appearance: CircularSliderAppearance(
                                              infoProperties: InfoProperties(
                                                mainLabelStyle: const TextStyle(
                                                    color: Colors.white),
                                                modifier: (value) {
                                                  _floors =
                                                      (value * 2).floor() / 2;
                                                  return _floors.toString();
                                                },
                                              ),
                                              size: 90),
                                          onChange: (double value) {
                                            Future.delayed(Duration.zero, () {
                                              setState(() {
                                                _floors =
                                                    (value * 2).floor() / 2;
                                              });
                                            });
                                          },
                                          onChangeEnd: (value) {
                                            runModel();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Waterfront
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: const [
                                            Flexible(
                                              child: Icon(
                                                Icons.beach_access,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Waterfront",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: SleekCircularSlider(
                                          min: 0,
                                          max: 1,
                                          initialValue: _waterfront ? 1 : 0,
                                          appearance: CircularSliderAppearance(
                                              infoProperties: InfoProperties(
                                                mainLabelStyle: const TextStyle(
                                                    color: Colors.white),
                                                modifier: (value) {
                                                  if (value > 0.5) {
                                                    _waterfront = true;
                                                    return "1";
                                                  } else {
                                                    _waterfront = false;
                                                    return "0";
                                                  }
                                                },
                                              ),
                                              size: 90),
                                          onChangeEnd: (double value) {
                                            setState(() {
                                              if (value > 0.5) {
                                                _waterfront = true;
                                              } else {
                                                _waterfront = false;
                                              }
                                            });
                                            runModel();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // View
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: const [
                                            Flexible(
                                              child: Icon(
                                                Icons.visibility,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Views",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: SleekCircularSlider(
                                          min: 0,
                                          max: 5,
                                          initialValue: _views as double,
                                          appearance: CircularSliderAppearance(
                                              infoProperties: InfoProperties(
                                                mainLabelStyle: const TextStyle(
                                                    color: Colors.white),
                                                modifier: (value) {
                                                  _views = value.ceil().toInt();
                                                  return _views.toString();
                                                },
                                              ),
                                              size: 90),
                                          onChange: (double value) {
                                            setState(() {
                                              _views = value.ceil().toInt();
                                            });
                                          },
                                          onChangeEnd: (value) {
                                            runModel();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Condition
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: const [
                                            Flexible(
                                              child: Icon(
                                                Icons.architecture,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Condition",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: SleekCircularSlider(
                                          min: 1,
                                          max: 5,
                                          initialValue: _condition as double,
                                          appearance: CircularSliderAppearance(
                                              infoProperties: InfoProperties(
                                                mainLabelStyle: const TextStyle(
                                                    color: Colors.white),
                                                modifier: (value) {
                                                  _condition =
                                                      value.ceil().toInt();
                                                  return conditions[
                                                      _condition - 1];
                                                },
                                              ),
                                              size: 90),
                                          onChange: (double value) {
                                            setState(() {
                                              _condition = value.ceil().toInt();
                                            });
                                          },
                                          onChangeEnd: (value) {
                                            runModel();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Grade
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: const [
                                            Flexible(
                                              child: Icon(
                                                Icons.grade,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Grade",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: SleekCircularSlider(
                                          min: 1,
                                          max: 13,
                                          initialValue: _grade as double,
                                          appearance: CircularSliderAppearance(
                                              infoProperties: InfoProperties(
                                                mainLabelStyle: const TextStyle(
                                                    color: Colors.white),
                                                modifier: (value) {
                                                  _grade = value.ceil().toInt();
                                                  return _grades.reversed
                                                      .elementAt(_grade - 1);
                                                },
                                              ),
                                              size: 90),
                                          onChange: (double value) {
                                            setState(() {
                                              _grade = value.ceil().toInt();
                                            });
                                          },
                                          onChangeEnd: (value) {
                                            runModel();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Sqft Above
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: const [
                                            Flexible(
                                              child: Icon(
                                                Icons.arrow_upward,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Above Area",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: SleekCircularSlider(
                                          min: 200,
                                          max: 10000,
                                          initialValue: _aboveArea as double,
                                          appearance: CircularSliderAppearance(
                                              infoProperties: InfoProperties(
                                                mainLabelStyle: const TextStyle(
                                                    color: Colors.white),
                                                modifier: (value) {
                                                  _aboveArea =
                                                      value.ceil().toInt();
                                                  return '$_aboveArea sqft';
                                                },
                                              ),
                                              size: 90),
                                          onChange: (double value) {
                                            setState(() {
                                              _aboveArea = value.ceil().toInt();
                                            });
                                          },
                                          onChangeEnd: (value) {
                                            runModel();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Sqft Basement
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: const [
                                            Flexible(
                                              child: Icon(
                                                Icons.arrow_downward,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Basement Area",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: SleekCircularSlider(
                                          min: 0,
                                          max: 5000,
                                          initialValue: _basementArea as double,
                                          appearance: CircularSliderAppearance(
                                              infoProperties: InfoProperties(
                                                mainLabelStyle: const TextStyle(
                                                    color: Colors.white),
                                                modifier: (value) {
                                                  _basementArea =
                                                      value.ceil().toInt();
                                                  return '$_basementArea sqft';
                                                },
                                              ),
                                              size: 90),
                                          onChange: (double value) {
                                            setState(() {
                                              _basementArea =
                                                  value.ceil().toInt();
                                            });
                                          },
                                          onChangeEnd: (value) {
                                            runModel();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Year Built
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: const [
                                            Flexible(
                                              child: Icon(
                                                Icons.calendar_month,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Year Built",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: SleekCircularSlider(
                                          min: 1900,
                                          max: 2015,
                                          initialValue: _yearBuilt as double,
                                          appearance: CircularSliderAppearance(
                                              infoProperties: InfoProperties(
                                                mainLabelStyle: const TextStyle(
                                                    color: Colors.white),
                                                modifier: (value) {
                                                  _yearBuilt =
                                                      value.ceil().toInt();
                                                  return _yearBuilt.toString();
                                                },
                                              ),
                                              size: 90),
                                          onChange: (double value) {
                                            setState(() {
                                              _yearBuilt = value.ceil().toInt();
                                            });
                                          },
                                          onChangeEnd: (value) {
                                            runModel();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Year Renovated
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: const [
                                            Flexible(
                                              child: Icon(
                                                Icons.home_repair_service,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Year Renovated",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: SleekCircularSlider(
                                          min: 1900,
                                          max: 2015,
                                          initialValue:
                                              _yearRenovated as double,
                                          appearance: CircularSliderAppearance(
                                              infoProperties: InfoProperties(
                                                mainLabelStyle: const TextStyle(
                                                    color: Colors.white),
                                                modifier: (value) {
                                                  _yearRenovated =
                                                      value.ceil().toInt();
                                                  if (_yearRenovated == 1900) {
                                                    return "None";
                                                  }
                                                  return _yearRenovated
                                                      .toString();
                                                },
                                              ),
                                              size: 90),
                                          onChange: (double value) {
                                            setState(() {
                                              _yearRenovated =
                                                  value.ceil().toInt();
                                            });
                                          },
                                          onChangeEnd: (value) {
                                            runModel();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Latitude
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: const [
                                            Flexible(
                                              child: Icon(
                                                Icons.map,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Latitude",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: SleekCircularSlider(
                                          min: 47.1559,
                                          max: 47.7776,
                                          initialValue: _latitude,
                                          appearance: CircularSliderAppearance(
                                              infoProperties: InfoProperties(
                                                mainLabelStyle: const TextStyle(
                                                    color: Colors.white),
                                                modifier: (value) {
                                                  _latitude = value;
                                                  return _latitude
                                                      .toStringAsFixed(4);
                                                },
                                              ),
                                              size: 90),
                                          onChange: (double value) {
                                            setState(() {
                                              _latitude = value;
                                            });
                                          },
                                          onChangeEnd: (value) {
                                            runModel();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Longitude
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: const [
                                            Flexible(
                                              child: Icon(
                                                Icons.map,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Longitude",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: SleekCircularSlider(
                                          min: -122.519000,
                                          max: -121.315000,
                                          initialValue: _longitude,
                                          appearance: CircularSliderAppearance(
                                              infoProperties: InfoProperties(
                                                mainLabelStyle: const TextStyle(
                                                    color: Colors.white),
                                                modifier: (value) {
                                                  _longitude = value;
                                                  return _longitude
                                                      .toStringAsFixed(4);
                                                },
                                              ),
                                              size: 90),
                                          onChange: (double value) {
                                            setState(() {
                                              _longitude = value;
                                            });
                                          },
                                          onChangeEnd: (value) {
                                            runModel();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const ChatPage(),
        ][MyApp.currentPageIndex],
      ),
    );
  }
}
