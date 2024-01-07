import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model.dart';

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
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final ValueNotifier<bool> isSheetOpenNotifier = ValueNotifier(false);

  List<Modelgenerated> universityList = [];

  Future<List<Modelgenerated>> getUserApi() async {
    List<Modelgenerated> universityList = [];

    try {
      final response = await http.get(Uri.parse('http://universities.hipolabs.com/search?country=United+States'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        for (Map i in data) {
          Modelgenerated autogenerated = Modelgenerated(name: i['name'], country: i['country']);
          universityList.add(autogenerated);
        }

        return universityList;
      } else {
        print('Error: ${response.statusCode}');
        return universityList;
      }
    } catch (e) {
      print('Error: $e');
      return universityList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              width: double.infinity,
              height: 380,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/College.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: 25,
              top: 18,
              left: 25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // Handle back button click.
                    },
                    child: Container(
                      height: 40,
                      width: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.transparent,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Container(
                      height: 40,
                      width: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.transparent,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.favorite_border,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              builder: (context, controller) {
                controller.addListener(() {
                  isSheetOpenNotifier.value = controller.position.pixels <= 0;
                });

                return Container(
                  padding: EdgeInsets.only(left: 25, right: 25, top: 37),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    color: Colors.white70
                  ),
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Top Universities",
                                  style: TextStyle(fontSize: 24),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.blue,
                                      size: 16,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "United States",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sort",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Icon(
                                    Icons.sort,
                                    size: 24,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        FutureBuilder(
                          future: getUserApi(),
                          builder: (context, AsyncSnapshot<List<Modelgenerated>> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 30,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 3,
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(16),
                                      leading: Icon(Icons.school, color: Colors.blue),
                                      title: Text(
                                        snapshot.data![index].name.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Location: " + snapshot.data![index].country.toString(),
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.favorite_border),
                                        onPressed: () {
                                          // Handle favorite button click.
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );

                            }
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: isSheetOpenNotifier,
                builder: (context, child) {
                  return isSheetOpenNotifier.value ? RoundButton() : FullSizeButton();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(24), // Make it round
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white,
          onTap: () {
            // Handle "Book Now" button click.
          },
          child: Center(
            child: Icon(
              Icons.location_history_rounded, // Add an icon to indicate booking
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class FullSizeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 325,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white,
          onTap: () {
            // Handle "Book Now" button click.
          },
          child: Center(
            child: Text(
              "Visit Now",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
