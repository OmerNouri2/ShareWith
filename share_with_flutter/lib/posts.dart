import 'package:flutter/material.dart';
import 'package:share_with/LoadingPage.dart';
import 'user_posts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:share_with/Item.dart';
import 'dart:convert';
import 'calc.dart';
import 'address.dart';

class MyPost extends StatefulWidget {
  final String category;
  final String userID;
  final DatabaseReference database;
  final String radiusPreference;
  double lat;
  double lon;
  final String userName;
  MyPost(this.category, this.userID, this.database, this.radiusPreference,
      this.lat, this.lon, this.userName);

  @override
  State<MyPost> createState() {
    return _MyPostState();
  }
}

class _MyPostState extends State<MyPost> {
  List<Item> itemsToDisplayInFeed = [];
  List<int> itemDistance = [];
  bool futureBeenCalled = false;
  bool noItemsAfterFilter = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2!,
      textAlign: TextAlign.center,
      child: FutureBuilder<bool>(
          future: _setItemsToDisplayInFeed(widget.category),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: itemsToDisplayInFeed.length,
                          itemBuilder: (context, index) {
                            String currUploaderName =
                                itemsToDisplayInFeed[index].uploaderName;
                            if (itemsToDisplayInFeed[index].userID ==
                                widget.userID) {
                              currUploaderName = "self";
                            }
                            return UserPosts(
                              itemDeletedUpdate,
                              itemsToDisplayInFeed[index].category,
                              widget.database,
                              itemsToDisplayInFeed[index].title,
                              itemsToDisplayInFeed[index].description,
                              itemsToDisplayInFeed[index].condition,
                              itemsToDisplayInFeed[index].url,
                              itemDistance[index],
                              currUploaderName,
                              itemsToDisplayInFeed[index].uploaderPhoneNumber,
                            );
                          }),
                    ),
                  ],
                );
              } else {
                // No items in selected category
                return Center(
                  child: new Text(
                      "Whoops! There are no items in this category in your area",
                      style: TextStyle(
                        fontSize: 22,
                        color: Color.fromARGB(255, 7, 176, 255),
                      )),
                );
              }
            } else {
              // Waiting for data to arrive from database
              return LoadingPage();
            }
          }),
    );
  }

  Future<bool> _setItemsToDisplayInFeed(String category) async {
    bool itemsExists = true;
    if (!mounted || futureBeenCalled) {
      if (noItemsAfterFilter) return false;
      return true;
    }
    DatabaseReference ref = widget.database.child('/Items/$category');
    DatabaseEvent event = await ref.once();

    if (!event.snapshot.exists) {
      itemsExists = false;
    } else {
      List<Item> itemsToDisplay = [];
      Map<String, dynamic> itemsAsMap =
          jsonDecode(jsonEncode(event.snapshot.value));
      List<String> itemsKeys = itemsAsMap.keys.toList();
      int numberOfItems = itemsKeys.length;
      for (int i = 0; i < numberOfItems; i++) {
        String itemKey = itemsKeys[i];
        String title = itemsAsMap[itemKey]["title"];
        String condition = itemsAsMap[itemKey]["condition"];
        String description = itemsAsMap[itemKey]["description"];
        String uploaderName = itemsAsMap[itemKey]["uploader_name"];
        String uploaderPhoneNumber =
            itemsAsMap[itemKey]["uploader_phone_number"];
        String uploaderAddress = itemsAsMap[itemKey]["uploader_address"];
        String itemUrl = itemsAsMap[itemKey]["item_url"];
        String itemUserID = itemsAsMap[itemKey]["user_id"];
        double uploaderLat = itemsAsMap[itemKey]["latitude"];
        double uploaderLon = itemsAsMap[itemKey]["longitude"];

        Item itemToDisplay = Item(
            title,
            category,
            condition,
            description,
            uploaderName,
            uploaderPhoneNumber,
            uploaderAddress,
            itemUrl,
            itemUserID,
            [uploaderLat, uploaderLon]);
        itemsToDisplay.add(itemToDisplay);
      }
      Calc calculateAddresses = new Calc(
          widget.radiusPreference, itemsToDisplay, [widget.lat, widget.lon]);

      List itemsAndDistances = await calculateAddresses.itemsToAddr();

      setState(() {
        itemsToDisplayInFeed = itemsAndDistances[0];
        itemDistance = itemsAndDistances[1];
        futureBeenCalled = true;
      });
    }

    if (itemsToDisplayInFeed.isEmpty) {
      setState(() {
        noItemsAfterFilter = true;
      });
      itemsExists = false;
    }

    return itemsExists;
  }

  void itemDeletedUpdate(String itemKey, String itemCategory, String itemName) {
    DatabaseReference itemRef =
        widget.database.child('/Items/$itemCategory/$itemKey');
    itemRef.remove();
  }
}
