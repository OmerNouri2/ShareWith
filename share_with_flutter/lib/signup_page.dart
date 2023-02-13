import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:provider/provider.dart';
import 'main.dart';
import 'User.dart';
import 'package:share_with/authentication_service.dart';

class StatefulSignupPage extends StatefulWidget {
  const StatefulSignupPage({Key? key}) : super(key: key);

  @override
  State<StatefulSignupPage> createState() => _StatefulSignupPageState();
}

class _StatefulSignupPageState extends State<StatefulSignupPage> {
  static const String _title = 'Sign Up';
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password_confirm_Controller = TextEditingController();
  TextEditingController city_Controller = TextEditingController();
  TextEditingController street_Controller = TextEditingController();
  TextEditingController house_num_Controller = TextEditingController();
  TextEditingController nicknameController = TextEditingController();

  String? user_email;
  String? user_password;
  String? user_phone_number;
  String? user_city;
  String? user_street;
  var user_house_num;
  String? user_nickname;
  bool passwordCheck = true;
  User? share_with_user;

  var maskFormatter = new MaskTextInputFormatter(
      mask: '###-#######',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  String dropDownDistancesHint = 'Distance';
  String? dropDownDistance;

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
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges,
            initialData: null,
          ),
        ],
        builder: (BuildContext context, Widget child) {
          return Scaffold(
            appBar: AppBar(title: const Text(_title)),
            body: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: nicknameController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            labelText: 'Username',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            labelText: 'Email Address',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10)),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            labelText: 'Phone Number',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10)),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [maskFormatter],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            labelText: 'Password',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        obscureText: true,
                        controller: password_confirm_Controller,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            labelText: 'Confirm Password',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        // obscureText: true,
                        controller: city_Controller,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            labelText: 'City',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        // obscureText: true,
                        controller: street_Controller,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            labelText: 'Street',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        // obscureText: true,
                        controller: house_num_Controller,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            labelText: 'House Number',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 150, 10),
                      child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              labelText: "Prefered Distance",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10)),
                          menuMaxHeight: 150,
                          isExpanded: false,
                          // hint: Text(dropDownDistancesHint, textAlign: TextAlign.end),
                          // Initial Value
                          value: dropDownDistance,
                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: distances.map((String items) {
                            return DropdownMenuItem(
                                value: items, child: Text(items));
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
                          onChanged: (String? newValue) {
                            setState(() {
                              dropDownDistance = newValue!;
                            });
                          }),
                    ),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            side: BorderSide(
                                color: Color.fromARGB(221, 0, 0, 0), width: 1),
                            primary: Color.fromARGB(255, 7, 176, 255), //Change
                            fixedSize: Size(100, 40),
                            elevation: 15,
                          ),
                          child: const Text('Submit'),
                          onPressed: () {
                            user_email = emailController.text;
                            if (password_confirm_Controller.text ==
                                passwordController.text) {
                              user_password = passwordController.text;
                            } else {
                              passwordCheck = false;
                            }
                            user_nickname = nicknameController.text;
                            user_phone_number = phoneController.text;
                            user_city = city_Controller.text;
                            user_street = street_Controller.text;
                            user_house_num = house_num_Controller.text;
                            final myUser = new ShareWithUser(
                                user_nickname,
                                user_email,
                                user_phone_number,
                                dropDownDistance,
                                user_city,
                                user_street,
                                user_house_num,
                                0,
                                0);
                            context
                                .read<AuthenticationService>()
                                .signUp(myUser, user_password);
                            Navigator.pop(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             AuthenticationWrapper()));
                          },
                        )),
                    Row(
                      children: <Widget>[
                        const Text('Have an account?'),
                        TextButton(
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             AuthenticationWrapper()));
                          },
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ],
                )),
          );
        });
  }
}
