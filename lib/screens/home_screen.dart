import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poms/screens/shopping_screen.dart';
import 'package:poms/utils/colors.dart';
import './user_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  late String _uid;

  @override
  Widget build(BuildContext context) {
    _uid = FirebaseAuth.instance.currentUser!.uid;
    List<Widget> _body = [
      Center(
        child: ShoppingScreen(),
      ),
      Center(
        child: UserProfileScreen(uid: _uid),
      ),
    ];
    return Scaffold(
      body: _body[_index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        unselectedIconTheme: const IconThemeData(color: UIColors.black),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Feed",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: "Profile",
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: _index,
        onTap: (value) {
          setState(() {
            _index = value;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
