import 'package:flutter/material.dart';
import 'dart:async';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _avatarAnimation;
  double _progressValue = 0.0;

  bool _showAllContacts = false;

  final List<Map<String, String>> _contacts = [
    {"name": "Mom", "image": "lib/assets/mom.jpg", "phone": "+91 9876543210"},
    {"name": "Dad", "image": "lib/assets/dad.jpg", "phone": "+91 8765432109"},
    {
      "name": "Sarah",
      "image": "lib/assets/sarah.jpg",
      "phone": "+91 7654321098",
    },
    {
      "name": "Mike",
      "image": "lib/assets/mike.avif",
      "phone": "+91 6543210987",
    },
    {"name": "John", "image": "lib/assets/john.jpg", "phone": "+91 5432109876"},
    {"name": "Emma", "image": "lib/assets/emma.jpg", "phone": "+91 4321098765"},
    {"name": "Sophia", "image": "assets/sophia.jpg", "phone": "+91 3210987654"},
  ];
  //-------------------------------------edit profile-----------------------------
  void _showEditProfileDialog() {
    TextEditingController nameController = TextEditingController(
      text: "Anna Jones",
    );
    TextEditingController ageController = TextEditingController(text: "24");
    TextEditingController locationController = TextEditingController(
      text: "New York, USA",
    );

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile Picture Change
                GestureDetector(
                  onTap: () {
                    // Add image picker functionality
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('lib/assets/profile.jpg'),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white70,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Name Field
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),

                // Age Field
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Age"),
                ),

                // Location Field
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: "Location"),
                ),

                const SizedBox(height: 15),

                // Save Button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Save new values
                      // Example: name = nameController.text;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade700,
                  ),
                  child: Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    // Avatar animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _avatarAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // Animate Circular Progress Indicator
    _animateProgress();
  }

  void _animateProgress() {
    Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {
        if (_progressValue < 0.85) {
          _progressValue += 0.01;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 36),
                // Settings Icon (Top Right)

                // Profile Section with Animated Avatar-------------------------------------------------
                ScaleTransition(
                  scale: _avatarAnimation,
                  child: Column(
                    children: [
                      // Profile Picture
                      Material(
                        elevation: 6, // 👈 Controls the shadow depth
                        shape: const CircleBorder(),
                        shadowColor: Colors.black,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('lib/assets/profile.jpg'),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Name + Edit Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Aditi Sharma",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap:
                                _showEditProfileDialog, // Open the dialog box
                            child: Icon(
                              Icons.edit,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      // Age
                      Text(
                        "Age: 24",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),

                      // Location
                      Text(
                        "Location: Allahabad, India",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                //---------------------------------------------contents-------------------------
                const SizedBox(height: 30),

                // Community Points Card
                _buildCommunityPointsCard(),

                const SizedBox(height: 30),

                // Trusted Contacts Section
                _buildTrustedContacts(),

                const SizedBox(height: 20),

                // Emergency Helpline Section
                _buildEmergencyHelplines(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityPointsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Your Community Points",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "+20 since last week",
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 10),

          // Level Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.pink.shade700,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Level 3",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Animated Points Indicator with two contributing colors
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  value: 0.85, // 85% progress
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.pink.shade700,
                  strokeWidth: 8,
                ),
              ),
              SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  value: 0.4, // 40% from Reviews
                  backgroundColor: Colors.transparent,
                  color: Colors.orange.shade400, // Helping Others
                  strokeWidth: 8,
                ),
              ),
              Text(
                "85",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Labels for Contributions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildContributionLabel("Reviews", Colors.orange.shade400),
              _buildContributionLabel("Helping Others", Colors.pink.shade700),
            ],
          ),
        ],
      ),
    );
  }

  // Helper function to build a label
  Widget _buildContributionLabel(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(color: Colors.black, fontSize: 14)),
      ],
    );
  }

  Widget _buildTrustedContacts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Trusted Contacts",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20),
            children: [
              ...(_showAllContacts ? _contacts : _contacts.take(4)).map(
                (contact) => Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                  ), // Spacing between contacts
                  child: _buildContact(
                    contact["name"]!,
                    contact["image"]!,
                    contact["phone"]!,
                  ),
                ),
              ),
              _buildViewAllButton(),
            ],
          ),
        ),
      ],
    );
  }

  // Contact Widget
  Widget _buildContact(String name, String imagePath, String phone) {
    return GestureDetector(
      onTap: () => _showContactDialog(name, imagePath, phone),
      child: Column(
        children: [
          CircleAvatar(radius: 30, backgroundImage: AssetImage(imagePath)),
          const SizedBox(height: 5),
          Text(name, style: TextStyle(color: Colors.black, fontSize: 14)),
        ],
      ),
    );
  }

  // View All Button
  Widget _buildViewAllButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showAllContacts = !_showAllContacts;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.pink.shade100,
            child: Icon(Icons.more_horiz, color: Colors.pink.shade700),
          ),
          const SizedBox(height: 5),
          Text(
            _showAllContacts ? "Show Less" : "View All",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Contact Detail Dialog-------------------------------------------------
  void _showContactDialog(String name, String imagePath, String phone) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController phoneController = TextEditingController(text: phone);
    bool isEditing = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(imagePath),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child:
                              isEditing
                                  ? TextField(
                                    controller: nameController,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                    autofocus: true,
                                  )
                                  : Text(
                                    nameController.text,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: double.infinity,
                          child:
                              isEditing
                                  ? TextField(
                                    controller: phoneController,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                    autofocus: true,
                                  )
                                  : Text(
                                    phoneController.text,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (isEditing) {
                                // Save functionality can be added here
                                print(
                                  "Saved Name: \${nameController.text}, Phone: \${phoneController.text}",
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Contact updated!'),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.only(
                                      top: 50,
                                      left: 20,
                                      right: 20,
                                    ),
                                  ),
                                );
                              }
                              isEditing = !isEditing;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isEditing
                                    ? Colors.green.shade700
                                    : Colors.pink.shade700,
                          ),
                          child: Text(
                            isEditing ? "Save" : "Edit",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //-------------------------------------------------------------------------------
}

Widget _buildEmergencyHelplines() {
  List<Map<String, dynamic>> helplines = [
    {"icon": Icons.local_police, "label": "Police", "color": Colors.blue},
    {"icon": Icons.local_hospital, "label": "Ambulance", "color": Colors.red},
    {"icon": Icons.child_care, "label": "Pregnancy", "color": Colors.orange},
    {
      "icon": Icons.local_fire_department,
      "label": "Fire",
      "color": Colors.deepOrange,
    },
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          "Emergency Helplines",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 15),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              helplines.map((helpline) {
                return Column(
                  children: [
                    FloatingActionButton(
                      backgroundColor: helpline["color"],
                      child: Icon(helpline["icon"], color: Colors.white),
                      onPressed: () {
                        // Add helpline call functionality
                      },
                    ),
                    const SizedBox(height: 5),
                    Text(
                      helpline["label"],
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    ],
  );
}
