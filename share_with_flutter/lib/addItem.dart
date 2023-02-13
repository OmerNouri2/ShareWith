// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_with/address.dart';
import 'package:path/path.dart';
import 'Item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddItem extends StatelessWidget {
  final String userID;
  final String userName;
  final String phoneNumber;
  final Address userAddress;
  final List<double> userCoor;
  AddItem(this.userID, this.userName, this.phoneNumber, this.userAddress,
      this.userCoor);

  static const String _title = 'Add Item';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    onPressed: () {
                      Navigator.of(context).pop(); // back to home page
                    }, // homePage
                    icon: Icon(Icons.home)),
              ],
              title: const Text(_title),
              backgroundColor: Color.fromARGB(255, 7, 176, 255),
            ),
            body: StatefulAddItem(this.userID, this.userName, this.phoneNumber,
                this.userAddress, this.userCoor),
          ),
        ));
  }
}

class StatefulAddItem extends StatefulWidget {
  final String userID;
  final String userName;
  final String phoneNumber;
  final Address userAddress;
  final List<double> userCoor;
  StatefulAddItem(this.userID, this.userName, this.phoneNumber,
      this.userAddress, this.userCoor);
  @override
  State<StatefulAddItem> createState() => _StatefulAddItemState();
}

class _StatefulAddItemState extends State<StatefulAddItem> {
  String? path;
  late String fileName;
  String url = "";

  String userItemTitle = "";
  String userItemDescription = "";

  String userItemCategoryHint = 'Select Category';
  String? userItemCategory;
  String itemConditionHint = 'Condition';
  String? userItemCondition;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController eCtrl = new TextEditingController();

  var categories = [
    'Food',
    'Electronic',
    'Toys & Hobbies',
    'Art',
    'Clothes',
    'Home & Garden',
  ];

  var itemConditions = [
    "Brand new",
    "Used",
    "Needs repair",
  ];
  var foodConditions = ["fresh", "about to expire", "recently made"];

  Future uploadFile() async {
    if (path == null) return;
    final fileName = basename(path!);
    final destination = 'files/$fileName';
    File file = File(path!);
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(file);
      url = await ref.getDownloadURL();
      // print(url);
    } catch (e) {
      print('error occured');
    }

    String userID = widget.userID;
    Address address = widget.userAddress;
    String addressAsString = address.streetNumber +
        ", " +
        address.streetAddress +
        ", " +
        address.city;
    final myItem = new Item(
        userItemTitle,
        userItemCategory!,
        userItemCondition!,
        userItemDescription,
        widget.userName,
        widget.phoneNumber,
        addressAsString,
        url,
        userID,
        widget.userCoor);
    myItem.addItemToDataBase(
      myItem,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //item name widget
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  hintText: 'Item Title',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: (String text) {
                userItemTitle = text;
              },
            ),
          ),
          // item Description widget
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  hintText: 'Description',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: (String text) {
                userItemDescription = text;
              },
            ),
          ),

          // drop-down category widget
          Container(
            padding: const EdgeInsets.all(10),
            child: DropdownButtonFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
                menuMaxHeight: 150,
                isExpanded: false,
                hint: Text(userItemCategoryHint),
                // Initial Value
                value: userItemCategory,
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),
                items: categories.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  userItemCondition = null;
                  setState(() {
                    userItemCategory = newValue!;
                  });
                }),
          ),

          // drop-down category widget
          Container(
            padding: const EdgeInsets.all(10),
            child: DropdownButtonFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
                menuMaxHeight: 150,
                isExpanded: false,
                hint: Text(itemConditionHint),
                // Initial Value
                value: userItemCondition,
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),
                items: userItemCategory == "Food"
                    ? foodConditions.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList()
                    : itemConditions.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value

                onChanged: (String? newValue) {
                  setState(() {
                    userItemCondition = newValue!;
                  });
                }),
          ),

          //ImagePicker
          Container(
            padding: EdgeInsets.fromLTRB(90, 10, 70, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      side: BorderSide(
                          color: Color.fromARGB(221, 0, 0, 0), width: 1),
                      primary: Color.fromARGB(255, 7, 176, 255), //Change
                      fixedSize: Size(100, 40),
                      elevation: 15,
                    ),
                    onPressed: () async {
                      final results = await ImagePicker.platform
                          .pickImage(
                              source: ImageSource.gallery, imageQuality: 41)
                          .whenComplete(() => {setState(() {})});
                      path = results!.path;
                      fileName = basename(path!);
                    },
                    child: Row(
                      children: [Text("Image "), Icon(Icons.image)],
                    )),
                SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      side: BorderSide(
                          color: Color.fromARGB(221, 0, 0, 0), width: 1),
                      primary: Color.fromARGB(164, 59, 255, 10), //Change
                      fixedSize: Size(125, 50),
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        uploadFile();
                      }
                      if ((userItemTitle != "") &
                          (userItemCategory != "") &
                          (userItemCondition != "") &
                          (userItemDescription != "")) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32.0))),
                            title: Row(
                              children: [
                                const Text('Item Submitted ',
                                    style: TextStyle(fontSize: 20)),
                                Icon(
                                  Icons.check_circle_outlined,
                                  color: Colors.green,
                                )
                              ],
                            ),
                            content: const Text(
                              'Thank you for your contribution',
                              style: TextStyle(fontSize: 14),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'Great!');
                                  Navigator.pop(context); // back to home page
                                },
                                child: const Text('Great!'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32.0))),
                            title: Row(
                              children: [
                                const Text('Error ',
                                    style: TextStyle(fontSize: 20)),
                                Icon(
                                  Icons.check_circle_outlined,
                                  color: Colors.green,
                                )
                              ],
                            ),
                            content: const Text(
                              'Missing information',
                              style: TextStyle(fontSize: 14),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'OK');
                                  // Navigator.pop(context); // back to home page
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          const Text(
                            'Submit ',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 15),
                          ),
                          Icon(
                            Icons.post_add,
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: GridView.builder(
                itemCount: 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: (path != null)
                        ? Image.file(
                            File(path!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  );
                }),
          ),
        ],
      ),
    );
  }
}
