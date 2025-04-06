import 'package:flutter/material.dart';
import 'package:sheshield/drawer%20pages/contacts.dart';
import 'package:sheshield/drawer%20pages/helpline.dart';
import 'package:sheshield/googleMap/homemap.dart';
import 'package:sheshield/sections/SOS.dart';
import 'package:sheshield/sections/call.dart';
import 'package:sheshield/sections/chat/chats.dart';
import 'package:sheshield/sections/community%20pages/community.dart';
import 'package:sheshield/sections/go.dart';
import 'package:sheshield/sections/profile.dart';
import 'package:sheshield/sections/notification.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isFabExpanded = false;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  bool _isCallActive = false;

  final List<Widget> _pages = [
    const Homemap(),
    const CommunityPage(),
    const SOSButton(),
    const SheShieldChatApp(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SOSButton()),
      );
    }
  }

  void _toggleFab() {
    setState(() {
      _isFabExpanded = !_isFabExpanded;
      if (_isFabExpanded) {
        _fabAnimationController.forward();
      } else {
        _fabAnimationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hi, Aditi 👋',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.pink[500],
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                iconSize: 28,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationPage(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 10,
                top: 5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.amber[700],
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text(
                'Aditi Sharma',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text('aditisharma07@gmail.com'),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0, // Adjust border thickness here
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('lib/assets/profile.jpg'),
                ),
              ),
              decoration: BoxDecoration(color: Colors.pink[700]),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(Icons.contacts, 'My Contacts'),
                  _buildDrawerItem(Icons.contacts, 'Emergency Helplines'),
                  _buildDrawerItem(Icons.place, 'My Places'),
                  _buildDrawerItem(Icons.notifications_active, 'Notifications'),
                  _buildDrawerItem(Icons.share, 'Share App'),
                  _buildDrawerItem(Icons.settings, 'Settings'),
                  const Divider(height: 1),
                  _buildDrawerItem(Icons.help, 'Help & Support'),
                  _buildDrawerItem(Icons.info, 'About App'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('LOGOUT'),
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.pink[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    // Handle logout
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutQuart),
              ),
              child: child,
            ),
          );
        },
        child: _pages[_selectedIndex],
      ),
      floatingActionButton: _buildExpandableFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        elevation: 10,
        child: Container(
          height: 60, // Reduced height to prevent overflow
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavBarItem(Icons.directions_run, 'Go', 0),
              _buildNavBarItem(Icons.groups, 'Community', 1),
              const SizedBox(width: 40), // Space for FAB
              _buildNavBarItem(Icons.chat, 'Chats', 3),
              _buildNavBarItem(Icons.person, 'Profile', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableFab() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_isFabExpanded)
          Transform.translate(
            offset: const Offset(0, -20),
            child: ScaleTransition(
              scale: _fabAnimation,
              child: FloatingActionButton(
                heroTag: 'sos',
                onPressed: () {
                  _toggleFab();
                  final snackBar = SnackBar(
                    content: Text(
                      'Location will be shared to nearest police station',
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: 'UNDO',
                      textColor: Colors.white,
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Location sharing cancelled'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Future.delayed(const Duration(seconds: 3), () {
                    if (snackBar.action != null) {
                      _shareLocationToPolice();
                    }
                  });
                },
                backgroundColor: Colors.red,
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        if (_isFabExpanded)
          Transform.translate(
            offset: const Offset(0, -10),
            child: ScaleTransition(
              scale: _fabAnimation,
              child: FloatingActionButton(
                heroTag: 'call',
                onPressed: () async {
                  _toggleFab();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CallingScreen(),
                    ),
                  );
                },
                backgroundColor: Colors.green,
                child: const Icon(Icons.call, color: Colors.white, size: 30),
              ),
            ),
          ),
        FloatingActionButton(
          heroTag: 'main',
          onPressed: _toggleFab,
          backgroundColor: Colors.pink[700],
          shape: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child:
                  _isFabExpanded
                      ? const Icon(
                        Icons.cancel,
                        key: ValueKey('cancel'),
                        color: Colors.white,
                        size: 36,
                      )
                      : const Icon(
                        Icons.call,
                        key: ValueKey('call'),
                        color: Colors.white,
                        size: 36,
                      ),
            ),
          ),
        ),
      ],
    );
  }

  // Add this method to handle the actual location sharing
  void _shareLocationToPolice() {
    // Implement your actual location sharing logic here
    print('Location shared to police');
    // You might want to show another snackbar confirming the sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Location successfully shared to police'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color:
                _selectedIndex == index ? Colors.pink[700] : Colors.grey[600],
            size: _selectedIndex == index ? 28 : 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color:
                  _selectedIndex == index ? Colors.pink[700] : Colors.grey[600],
              fontSize: 12,
              fontWeight:
                  _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Inside your _HomeScreenState class, replace the _buildDrawerItem method with:

  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink[700]),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context); // Close the drawer

        switch (title) {
          case 'My Contacts':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyContactsPage()),
            );
            break;
          case 'Emergency Helplines':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HelplineScreen()),
            );
            break;
          case 'My Places':
            // Navigate to places page
            break;
          case 'Notifications':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationPage()),
            );
            break;
          case 'Share App':
            // Implement share functionality
            break;
          case 'Settings':
            // Navigate to settings page
            break;
          case 'Help & Support':
            // Navigate to help page
            break;
          case 'About App':
            // Navigate to about page
            break;
          default:
            break;
        }
      },
    );
  }
}
