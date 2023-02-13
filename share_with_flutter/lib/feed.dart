import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:share_with/User.dart';

import 'Item.dart';
import 'LoadingPage.dart';
import 'my_uploads.dart';
import 'posts.dart';
import 'addItem.dart';
import 'myAccount.dart';
import 'authentication_service.dart';
import 'address.dart';

class FeedWidget extends StatefulWidget {
  String userID;
  DatabaseReference database;

  FeedWidget(this.userID, this.database);

  @override
  State<FeedWidget> createState() {
    return FeedWidgetState();
  }
}

class FeedWidgetState extends State<FeedWidget> {
  String userName = "";
  String userEmail = "";
  String userRadius = "";
  String userCity = "";
  String userStreetAddress = "";
  String userStreetNumber = "";
  String userPhoneNumber = "";
  List<double> userCoor = [];
  double userLat = 0;
  double userLon = 0;
  List<Item> userItemsList = [];
  List<Address> otherUsersAddresses = [];
  List<Map> userItemsMap = [];
  bool futureBeenCalled = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FutureBuilder(
            future: _setAllUserData(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                return NestedScrollView(
                  physics: BouncingScrollPhysics(),
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        toolbarHeight: 60,
                        backgroundColor: Color.fromARGB(255, 7, 176, 255),
                        leading: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Image.asset('assets/images/logos.png'),
                        ),
                        title: Row(
                          children: [
                            SizedBox(width: 5),
                          ],
                        ),
                        actions: [
                          IconButton(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddItem(
                                          widget.userID,
                                          userName,
                                          userPhoneNumber,
                                          Address(userCity, userStreetAddress,
                                              userStreetNumber),
                                          userCoor),
                                      settings:
                                          RouteSettings(name: '/AddItem')),
                                );
                              }, //Add Item
                              icon: Icon(Icons.add)),
                          IconButton(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              onPressed: () async {
                                setState(() => isLoading = true);
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                setState(() => isLoading = false);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyUploads(
                                          widget.database,
                                          userItemsList,
                                          widget.userID,
                                          userName,
                                          userPhoneNumber,
                                          Address(userCity, userStreetAddress,
                                              userStreetNumber),
                                          userCoor),
                                      settings:
                                          RouteSettings(name: '/MyUploads')),
                                );
                              }, //MY ACCOUNT
                              icon: Icon(Icons.article)),
                          IconButton(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StatefulmyAccount(
                                          widget.database,
                                          widget.userID,
                                          userName,
                                          userEmail,
                                          userRadius,
                                          userCity,
                                          userStreetAddress,
                                          userStreetNumber,
                                          userPhoneNumber,
                                          accountUpdated)),
                                );
                              }, //MY ACCOUNT
                              icon: Icon(Icons.account_circle)),
                          IconButton(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              onPressed: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext showDialogContext) =>
                                      AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0))),
                                    title: Text(
                                      'Log out of $userName?',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              showDialogContext, 'Log Out');
                                          context
                                              .read<AuthenticationService>()
                                              .signOut();
                                        },
                                        child: const Text('Log Out'),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(16.0),
                                          primary: Colors.red,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              showDialogContext, 'Cancel');
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                    ],
                                  ),
                                );
                              }, //sign out
                              icon: Icon(Icons.logout)),
                        ],
                      ),
                    ];
                  },
                  body: _TabBarContent(
                    tabs: [
                      Text(
                        "Home & Garden",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        "Electronic",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        "Food",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        "Toys & Hobbies",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        "Art",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        "Clothes",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                    children: [
                      callUserPost("Home & Garden"),
                      callUserPost("Electronic"),
                      callUserPost("Food"),
                      callUserPost("Toys & Hobbies"),
                      callUserPost("Art"),
                      callUserPost("Clothes"),
                    ],
                  ),
                );
              } else {
                // Waiting for data to arrive from database

                return LoadingPage();
              }
            }));
  }

  Widget callUserPost(String category) {
    return MyPost(category, widget.userID, widget.database, userRadius, userLat,
        userLon, userName);
  }

  Future<bool> _setAllUserData() async {
    if (!mounted || futureBeenCalled) return true;
    await setUserItemsList();

    DatabaseReference ref = widget.database.child('/Users/${widget.userID}');
    DatabaseEvent event = await ref.once();
    Map<String, dynamic> userAsMap =
        jsonDecode(jsonEncode(event.snapshot.value));
    String userNameFromDatabase = userAsMap["name"];
    String userEmailFromDatabase = userAsMap["email_address"];
    String userRadiusFromDatabase = userAsMap["radius_preference"];
    String userCityFromDatabase = userAsMap["city"];
    String userStreetAddressFromDatabase = userAsMap["street_address"];
    String userStreetNumberFromDatabase = userAsMap["street_number"];
    String userPhoneNumberFromDatabase = userAsMap["user_phone_number"];
    double userLatitudeFromDatabase = userAsMap["latitude"];
    double userLongitudeFromDatabase = userAsMap["longitude"];

    setState(() {
      userName = userNameFromDatabase;
      userEmail = userEmailFromDatabase;
      userRadius = userRadiusFromDatabase;
      userCity = userCityFromDatabase;
      userStreetAddress = userStreetAddressFromDatabase;
      userStreetNumber = userStreetNumberFromDatabase;
      userPhoneNumber = userPhoneNumberFromDatabase;
      userCoor = [userLatitudeFromDatabase, userLongitudeFromDatabase];
      userLat = userLatitudeFromDatabase;
      userLon = userLongitudeFromDatabase;
    });

    return true;
  }

  Future<void> setUserItemsList() async {
    var categories = [
      'Food',
      'Electronic',
      'Toys & Hobbies',
      'Art',
      'Clothes',
      'Home & Garden',
    ];

    List<Item> userItems = [];
    for (int i = 0; i < categories.length; i++) {
      DatabaseReference ref = widget.database.child('/Items/${categories[i]}');
      ref.onValue.listen((DatabaseEvent event) {
        if (event.snapshot.exists) {
          Map<String, dynamic> itemsAsMap =
              jsonDecode(jsonEncode(event.snapshot.value));
          List<String> itemsKeys = itemsAsMap.keys.toList();
          int numberOfItems = itemsKeys.length;

          for (int j = 0; j < numberOfItems; j++) {
            String itemKey = itemsKeys[j];

            // check if item is of the current user
            if (itemsAsMap[itemKey]["user_id"] != widget.userID) {
              continue;
            }

            userItemsMap.add({"category": categories[i], 'item_key': itemKey});

            String title = itemsAsMap[itemKey]["title"];
            String category = categories[i];
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

            Item userItem = Item(
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
            userItems.add(userItem);
          }
        }
      });
    }
    setState(() {
      userItemsList = userItems;
      futureBeenCalled = true;
    });
  }

  void accountUpdated(ShareWithUser updatedUser) async {
    String addressAsString = updatedUser.streetNumber! +
        ", " +
        updatedUser.streetAddress! +
        ", " +
        updatedUser.city!;
    userItemsMap.forEach(
      (itemMap) async {
        DatabaseReference ref = widget.database
            .child('/Items/${itemMap['category']}/${itemMap['item_key']}');
        await ref.update({
          "uploader_name": updatedUser.nickname!,
          "uploader_address": addressAsString,
          'uploader_phone_number': updatedUser.phoneNumber,
        });
      },
    );

    setState(() {
      userName = updatedUser.nickname!;
      userEmail = updatedUser.emailAddress!;
      userRadius = updatedUser.radiusePreference!;
      userCity = updatedUser.city!;
      userStreetAddress = updatedUser.streetAddress!;
      userStreetNumber = updatedUser.streetNumber!;
      userPhoneNumber = updatedUser.phoneNumber!;
    });
  }
}

class _TabBarContent extends StatelessWidget {
  const _TabBarContent({required this.tabs, required this.children, Key? key})
      : super(key: key);

  final List<Widget> tabs;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: TabBar(
              tabs: tabs,
              unselectedLabelColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColor,
              isScrollable: true,
            ),
          ),
          SizedBox(height: 5),
          Expanded(
            child: TabBarView(children: children),
          ),
        ],
      ),
    );
  }
}
