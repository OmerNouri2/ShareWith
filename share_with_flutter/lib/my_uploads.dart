import 'package:flutter/material.dart';
import 'Item.dart';
import 'addItem.dart';
import 'address.dart';
import 'user_posts.dart';
import 'package:firebase_database/firebase_database.dart';

class MyUploads extends StatelessWidget {
  final DatabaseReference database;
  final List<Item> myItems;
  final String userId;
  final String userName;
  final String phoneNumber;
  final Address userAddress;
  List<double> userCoor;
  MyUploads(this.database, this.myItems, this.userId, this.userName,
      this.phoneNumber, this.userAddress, this.userCoor);

  static const String _title = 'My Uploads';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(_title),
          backgroundColor: Color.fromARGB(255, 7, 176, 255),
          actions: <Widget>[
            IconButton(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddItem(userId, userName,
                            phoneNumber, userAddress, userCoor)),
                  );
                }, //Add Item
                icon: Icon(Icons.add)),
            IconButton(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                onPressed: () {
                  Navigator.of(context).pop(); // back to home page
                }, // homePage
                icon: Icon(Icons.home)),
          ],
        ),
        body: StatefulUploads(this.database, this.myItems),
      ),
    );
  }
}

class StatefulUploads extends StatefulWidget {
  final DatabaseReference database;
  final List<Item> myItems;
  StatefulUploads(this.database, this.myItems);

  @override
  State<StatefulUploads> createState() => MyUploadsState();
}

class MyUploadsState extends State<StatefulUploads> {
  List<Item> myUploadedItems = [];
  @override
  void initState() {
    super.initState();
    myUploadedItems = widget.myItems;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: Theme.of(context).textTheme.headline2!,
        textAlign: TextAlign.center,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: myUploadedItems.length,
                  itemBuilder: (context, index) {
                    return UserPosts(
                      itemDeletedUpdate,
                      myUploadedItems[index].category,
                      widget.database,
                      myUploadedItems[index].title,
                      myUploadedItems[index].description,
                      myUploadedItems[index].condition,
                      myUploadedItems[index].url,
                    );
                  }),
            ),
          ],
        ));
  }

  void itemDeletedUpdate(String itemKey, String itemCategory, String itemName) {
    DatabaseReference itemRef =
        widget.database.child('/Items/$itemCategory/$itemKey');
    itemRef.remove();
    List<Item> currItemList = this.myUploadedItems;
    for (int i = 1; i < currItemList.length; i++) {
      if (itemName == currItemList[i].title) {
        currItemList.removeAt(i);
        break;
      }
    }
    setState(() {
      this.myUploadedItems = currItemList;
    });
  }
}
