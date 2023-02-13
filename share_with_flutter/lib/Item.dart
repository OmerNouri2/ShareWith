import 'package:firebase_database/firebase_database.dart';

class Item {
  final String title;
  final String category;
  final String condition;
  final String description;
  final String uploaderName;
  final String uploaderPhoneNumber;
  final String addressAsString;
  final String url;
  final String userID;
  final List<double> uploaderCoordinates;

  Item(
      this.title,
      this.category,
      this.condition,
      this.description,
      this.uploaderName,
      this.uploaderPhoneNumber,
      this.addressAsString,
      this.url,
      this.userID,
      this.uploaderCoordinates);

  void addItemToDataBase(Item item) async {
    DatabaseReference database = FirebaseDatabase.instance.ref();
    final shareWithItems = database.child('/Items/${item.category}');

    shareWithItems.push().set({
      "title": "${item.title}",
      "condition": "${item.condition}",
      "description": "${item.description}",
      "user_id": "${item.userID}",
      "uploader_name": "$uploaderName",
      "uploader_phone_number": "$uploaderPhoneNumber",
      "uploader_address": "$addressAsString",
      "item_url": "$url",
      "latitude": uploaderCoordinates[0],
      "longitude": uploaderCoordinates[1],
    });
  }
}
