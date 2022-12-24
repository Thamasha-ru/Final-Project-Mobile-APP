import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StateChanger extends StatefulWidget {
  final String title;

  const StateChanger({
    required this.title,
  });

  @override
  State<StateChanger> createState() => _StateChangerState();
}

class _StateChangerState extends State<StateChanger> {
  bool value = true;

  // TODO: get the user from the firestore
  final dummyName = "angela@gmail.com";
  final users = FirebaseFirestore.instance.collection('users');

  Future changeCovidStatus(bool value) async {
    return users.doc(dummyName).set({"covidStatus": value});
  }

  Future getTheUsesCovidStatus() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> status =
          await users.doc(dummyName).get();
      Map<String, dynamic>? data = status.data();
      if (data != null) {
        setState(() {
          value = data['covidStatus'] as bool;
        });
      }
    } catch (e) {
      // TODO: error handling
    }
  }

  @override
  void initState() {
    getTheUsesCovidStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Spacer(),
            Image.asset(
              // value ? 'assets/images/on.png' : 'assets/images/off.png',
              value
                  ? 'assets/images/positive.PNG'
                  : 'assets/images/negative.PNG',
              height: 300,
            ),
            Spacer(),
            buildPlatforms(),
            const SizedBox(height: 12),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget buildPlatforms() => Row(
        children: [
          Expanded(
            child: buildHeader(
                text: value == true ? 'Covid Positive' : 'Covid Negative',
                child: buildIOSSwitch()),
          ),
        ],
      );

  Widget buildHeader({
    required Widget child,
    required String text,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          child,
        ],
      );

  Widget buildIOSSwitch() => Transform.scale(
        scale: 1.1,
        child: CupertinoSwitch(
          value: value,
          onChanged: (value) async {
            try {
              await changeCovidStatus(value);
              setState(() => this.value = value);
            } catch (e) {
              // TODO: add error dialog
            }
          },
        ),
      );

  Widget buildAndroidSwitch() => Transform.scale(
        scale: 2,
        child: Switch(
          value: value,
          onChanged: (value) async {
            try {
              await changeCovidStatus(value);
              setState(() => this.value = value);
            } catch (e) {
              // TODO: add error dialog
            }
          },
        ),
      );
}
