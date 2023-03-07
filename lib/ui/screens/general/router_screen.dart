import 'package:crypto_world/ui/screens/credentials/settings_error_screen.dart';
import 'package:crypto_world/ui/screens/credentials/settings_screen.dart';
import 'package:crypto_world/ui/screens/general/home_screen.dart';
import 'package:crypto_world/utils/constants.dart';
import 'package:flutter/material.dart';

class RouterScreen extends StatefulWidget {
  const RouterScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final String userID;

  @override
  State<RouterScreen> createState() => _RouterScreenState();
}

class _RouterScreenState extends State<RouterScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    _pages = widget.userID == kGuestID
        ? [
            HomeScreen(userID: widget.userID),
            SettingsErrorScreen(userID: widget.userID),
          ]
        : [
            HomeScreen(userID: widget.userID),
            SettingsScreen(userID: widget.userID),
          ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kMainBGColor,
              kDarkBlue,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            // colors: [
            //   kMainBGColor,
            //   kDarkBlue,
            // ],
            // begin: Alignment.topCenter,
            // end: Alignment.bottomCenter,
            // colors: [
            //   kMainBGColor,
            //   kMainBGColor,
            //   kDarkBlue,
            // ],
            // begin: Alignment.topLeft,
            // end: Alignment.bottomRight,
          ),
        ),
        child: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          currentIndex: _selectedIndex,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: kThemeColor,
          unselectedItemColor: kThemeColor.withOpacity(0.5),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
