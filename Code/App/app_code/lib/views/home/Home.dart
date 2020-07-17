import 'package:flutter/material.dart';
import 'package:mtahackathon/utils/constants.dart';
import 'package:mtahackathon/views/bookings/bookings.dart';
import 'package:mtahackathon/views/bookings/bookings_root_view.dart';
import 'package:mtahackathon/views/profile/profile.dart';
import 'package:mtahackathon/views/profile/profile_root.dart';
import 'package:mtahackathon/views/trains/trains_root_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentIndex,
          children: allDestinations.map<Widget>((Fragment fragment) {
            switch (fragment.title) {
              case 'Profile':
                return ProfileRootView(fragment: fragment);
              case 'Bookings':
                return BookingsRootView(fragment: fragment);
              case 'Trains':
                return TrainsRootView(fragment: fragment);
              default:
                return ProfileView(fragment: fragment);
            }
          }).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: Constants.globalKey,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: allDestinations.map((Fragment fragment) {
          return BottomNavigationBarItem(
              icon: Icon(fragment.icon), title: Text(fragment.title));
        }).toList(),
      ),
    );
  }
}

const List<Fragment> allDestinations = <Fragment>[
  Fragment('Profile', Icons.account_circle),
  Fragment('Trains', Icons.train),
  Fragment('Bookings', Icons.event_note),
];

class Fragment {
  const Fragment(this.title, this.icon);

  final String title;
  final IconData icon;
}

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
