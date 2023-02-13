import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

class UserPosts extends StatelessWidget {
  final DatabaseReference database;
  final String name;
  final String description;
  final String condition;
  final String contact;
  final String phone;
  final String image;
  final String category;
  final int distance;
  final updateParent;
  UserPosts(this.updateParent, this.category, this.database, this.name,
      this.description, this.condition, this.image,
      [this.distance = 0, this.contact = "-", this.phone = "000"]);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 3, //The gap on top of the page
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 182, 182, 182),
              shape: BoxShape.rectangle),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              //This is were the images should be
              Container(
                width: 140,
                height: 140,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(image),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                  width: 200,
                  height: 140,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 5,
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                  text: name,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                  text: description,
                                  style: TextStyle(fontSize: 14))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Condition: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: condition)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                        height: 4,
                      ),
                      distanceDisplay(),
                      SizedBox(
                        height: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: getWidget(context),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ))
            ],
          ),
        ),
        //post
        Container(
          height: 1, //The gap between items
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 182, 182, 182),
              shape: BoxShape.rectangle),
        ),
      ],
    );
  }

  Widget getWidget(BuildContext context) {
    if ((contact == "-" && phone == "000") || contact == "self") {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          side: BorderSide(color: Color.fromARGB(221, 0, 0, 0), width: 2),
          primary: Colors.red,
          fixedSize: Size(10, 10),
          elevation: 15,
        ),
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 22,
        ),
        onPressed: () {
          removeItemFromDatabase();
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title: Row(
                children: [
                  Text('Successfully Deleted Item'),
                  Icon(
                    Icons.check_circle_outlined,
                    color: Colors.green,
                  )
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Great!');
                  },
                  child: const Text('Great!'),
                ),
              ],
            ),
          );
        },
      );
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(8.0),
          primary: Color.fromARGB(255, 7, 176, 255),
          fixedSize: Size(150, 40),
          textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          shape: StadiumBorder(),
          elevation: 15,
          // shadowColor: Color.fromARGB(255, 7, 176, 255),
          side: BorderSide(color: Color.fromARGB(221, 0, 0, 0), width: 2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Call ' + contact),
          Icon(Icons.call_rounded),
        ],
      ),
      onPressed: () async {
        await FlutterPhoneDirectCaller.callNumber(phone);
      },
    );
  }

  Widget distanceDisplay() {
    if ((contact == "-" && phone == "000") || contact == "self") {
      return SizedBox(
        height: 0,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: 'Distance: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: distance.toStringAsFixed(0)),
            TextSpan(
              text: ' Meters',
            ),
          ],
        ),
      ),
    );
  }

  void removeItemFromDatabase() async {
    DatabaseReference ref = this.database.child('/Items/${this.category}');
    Query query = ref.orderByChild("title").limitToFirst(1).equalTo(this.name);
    var temp = await query.get();
    Map<String, dynamic> itemsAsMap = jsonDecode(jsonEncode(temp.value));
    List<String> itemKey = itemsAsMap.keys.toList();
    updateParent(itemKey[0], this.category, this.name);
  }
}
