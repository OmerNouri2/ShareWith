import 'package:firebase_database/firebase_database.dart';
import 'calc.dart';
import 'address.dart';

class ShareWithUser {
  final String? nickname;
  final String? emailAddress;
  final String? phoneNumber;
  final String? radiusePreference;
  final String? city;
  final String? streetAddress;
  final String? streetNumber;
  double? latitude;
  double? longitude;

  ShareWithUser(
      this.nickname,
      this.emailAddress,
      this.phoneNumber,
      this.radiusePreference,
      this.city,
      this.streetAddress,
      this.streetNumber,
      this.latitude,
      this.longitude);

  void addUserToDataBase(String userID) async {
    DatabaseReference database = FirebaseDatabase.instance.ref();
    final shareWithUsers = database.child('/Users');
    String address_as_string =
        this.streetNumber! + ", " + this.streetAddress! + ", " + this.city!;
    Calc calculateAddresses = new Calc("", [], []);
    List coordinate = await calculateAddresses.getCordinate(address_as_string);

    shareWithUsers.child("/$userID").set({
      "name": "${this.nickname}",
      "email_address": "${this.emailAddress}",
      "user_phone_number": "${this.phoneNumber}",
      "radius_preference": "${this.radiusePreference}",
      "city": "${this.city}",
      "street_address": "${this.streetAddress}",
      "street_number": "${this.streetNumber}",
      "latitude": coordinate[0],
      "longitude": coordinate[1],
    });
  }
}
