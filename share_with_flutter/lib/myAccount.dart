import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'User.dart';
import 'calc.dart';
import 'address.dart';

class StatefulmyAccount extends StatefulWidget {
  DatabaseReference database;
  String userID;
  String userName;
  String userEmail;
  String userRadius;
  String userCity;
  String userStreetAddress;
  String userStreetNumber;
  String userPhoneNumber;
  final updateParent;
  StatefulmyAccount(
      this.database,
      this.userID,
      this.userName,
      this.userEmail,
      this.userRadius,
      this.userCity,
      this.userStreetAddress,
      this.userStreetNumber,
      this.userPhoneNumber,
      this.updateParent);

  @override
  State<StatefulmyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<StatefulmyAccount> {
  TextEditingController nameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController radiusCont = TextEditingController();
  TextEditingController cityCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController streetNumCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();

  String dropDowndistancesHint = 'Select radius prefernce';
  String? dropDownDistance = "";
  bool edit = false;

  var maskFormatter = new MaskTextInputFormatter(
      mask: '###-#######',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  void initState() {
    super.initState();
    nameCont.text = widget.userName;
    emailCont.text = widget.userEmail;
    dropDownDistance = widget.userRadius;
    cityCont.text = widget.userCity;
    addressCont.text = widget.userStreetAddress;
    streetNumCont.text = widget.userStreetNumber;
    phoneCont.text = widget.userPhoneNumber;
  }

  List<String> distances = [
    '300 m',
    '500 m',
    '800 m',
    '1.0 km',
    '1.5 km',
    '2.0 km',
    '2.5 km',
    '3.0 km',
    '10 k.m',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  onPressed: () {
                    Navigator.of(context).pop(); // back to home page
                  }, // homePage
                  icon: Icon(Icons.home)),
            ],
            backgroundColor: Color.fromARGB(255, 7, 176, 255),
            title: const Text('My Account')),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                enabled: edit,
                controller: nameCont,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    labelText: 'User Name',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                enabled: edit,
                controller: emailCont,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    labelText: 'Email',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                enabled: edit,
                controller: cityCont,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    labelText: 'City',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                enabled: edit,
                controller: addressCont,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    labelText: 'Street address',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
                keyboardType: TextInputType.streetAddress,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                enabled: edit,
                controller: streetNumCont,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    labelText: 'Street number',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                enabled: edit,
                controller: phoneCont,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    labelText: 'Phone number',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
                keyboardType: TextInputType.phone,
                inputFormatters: [maskFormatter],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      labelText: 'Radius',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
                  menuMaxHeight: 150,
                  isExpanded: false,
                  hint: Text(dropDowndistancesHint, textAlign: TextAlign.end),

                  // Initial Value
                  value: dropDownDistance,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: distances.map((String items) {
                    return DropdownMenuItem(value: items, child: Text(items));
                  }).toList(),

                  // After selecting the desired option,it will
                  // change button value to selected value
                  selectedItemBuilder: (BuildContext context) {
                    return distances.map<Widget>((String item) {
                      return Container(
                          alignment: Alignment.centerLeft,
                          width: 150,
                          child: Text(item, textAlign: TextAlign.end));
                    }).toList();
                  },
                  onChanged: edit == false
                      ? null
                      : (String? newValue) {
                          setState(() {
                            dropDownDistance = newValue!;
                          });
                        }),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(90, 10, 90, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: (() => {edit = true, setState(() {})}),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        side: BorderSide(
                            color: Color.fromARGB(221, 0, 0, 0), width: 1),
                        primary: Color.fromARGB(255, 7, 176, 255), //Change
                        fixedSize: Size(80, 40),
                        elevation: 15,
                      ),
                      child: Row(
                        children: [
                          Text("Edit "),
                          Icon(
                            Icons.edit,
                            size: 19,
                          )
                        ],
                      )),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      side: BorderSide(
                          color: Color.fromARGB(221, 0, 0, 0), width: 1),
                      primary: Color.fromARGB(255, 7, 176, 255), //Change
                      fixedSize: Size(105, 40),
                      elevation: 15,
                    ),
                    onPressed: (() => {
                          widget.userName = nameCont.text,
                          widget.userEmail = emailCont.text,
                          widget.userCity = cityCont.text,
                          widget.userStreetAddress = addressCont.text,
                          widget.userStreetNumber = streetNumCont.text,
                          widget.userPhoneNumber = phoneCont.text,
                          widget.userRadius = radiusCont.text,
                          updateUser(),
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0))),
                              title: Row(
                                children: [
                                  const Text('Information Updated '),
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
                          ),
                          setState(() {
                            edit = false;
                          })
                        }),
                    child: Row(
                      children: [Text("Update"), Icon(Icons.update_outlined)],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void updateUser() async {
    DatabaseReference ref = widget.database.child('/Users/${widget.userID}');
    String address_as_string =
        streetNumCont.text + ", " + addressCont.text + ", " + cityCont.text;
    Calc calculateAddresses = new Calc("", [], []);
    List<double> coordinate =
        await calculateAddresses.getCordinate(address_as_string);
    await ref.update({
      "name": nameCont.text,
      "email_address": emailCont.text,
      "radius_preference": dropDownDistance,
      "city": cityCont.text,
      "street_address": addressCont.text,
      "street_number": streetNumCont.text,
      "user_phone_number": phoneCont.text,
      "latitude": coordinate[0],
      "longitude": coordinate[1],
    });

    widget.updateParent(ShareWithUser(
        nameCont.text,
        emailCont.text,
        phoneCont.text,
        dropDownDistance,
        cityCont.text,
        addressCont.text,
        streetNumCont.text,
        coordinate[0],
        coordinate[1]));
  }
}
