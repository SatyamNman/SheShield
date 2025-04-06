import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sheshield/sections/community%20pages/aboutcommunity.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<Map<String, dynamic>> hackathons = [
    {
      'title': 'She Power',
      'location': 'Goa',
      'Members': 128,
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_lflIVMasIueDq9rzP4ldkfG-EXLW5VF61sXbuiPWEITQfQ_QH55JFan0o1WgQoEYbSg&usqp=CAU',
    },
    {
      'title': 'Women Empowerment Network',
      'location': 'Hyderabad, Telangana',
      'Members': 92,
      'image':
          'https://img.freepik.com/premium-photo/woman-gracefully-walks-down-dimly-lit-street-night-surrounded-by-soft-glow-streetlights-silhouette-young-woman-walking-home-alone-night-ai-generated_538213-35443.jpg',
    },
    {
      'title': 'Rural Artisans Collective',
      'location': 'Kutch, Gujarat',
      'Members': 215,
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGLkOb3znwjwPdkDKx2kRLp4V3s1LK9siH-UiRJUsCsN3hwEKIpnA-2aDhzsUyD-JqduU&usqp=CAU',
    },
    {
      'title': 'Mental Health Allies',
      'location': 'Delhi',
      'Members': 341,
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3T0_q3EoedJ1sP0kzAoCeoetMARbVNT8oTA&s',
    },
    {
      'title': 'Queer Voices',
      'location': 'Kolkata, West Bengal',
      'Members': 176,
      'image':
          'https://media.istockphoto.com/id/1281645435/photo/one-young-alone-woman-in-white-jacket-walking-on-sidewalk-through-alley-of-trees-under-lamp.jpg?s=612x612&w=0&k=20&c=6NOAvFLwfFhcRntgaOo9Z45-2mqFs5FsKw9FTbwJ8Mk=',
    },
    {
      'title': 'Farmers Innovation Hub',
      'location': 'Punjab',
      'Members': 84,
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3T0_q3EoedJ1sP0kzAoCeoetMARbVNT8oTA&s',
    },
    {
      'title': 'Disabled & Proud',
      'location': 'Chennai, Tamil Nadu',
      'Members': 63,
      'image':
          'https://media.istockphoto.com/id/1281645435/photo/one-young-alone-woman-in-white-jacket-walking-on-sidewalk-through-alley-of-trees-under-lamp.jpg?s=612x612&w=0&k=20&c=6NOAvFLwfFhcRntgaOo9Z45-2mqFs5FsKw9FTbwJ8Mk=',
    },
    {
      'title': 'Indigenous Wisdom Keepers',
      'location': 'Shillong, Meghalaya',
      'Members': 42,
      'image':
          'https://img.freepik.com/premium-photo/woman-looking-stars_379823-13496.jpg',
    },
  ];
  //FILTER OPTION-------------------------------------------------------------------
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Reduced border radius
          ),
          title: Text("Filter Communities"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Region"),
                  items:
                      [
                        "All",
                        "Andhra Pradesh",
                        "Arunachal Pradesh",
                        "Assam",
                        "Bihar",
                        "Chhattisgarh",
                        "Goa",
                        "Gujarat",
                        "Haryana",
                        "Himachal Pradesh",
                        "Jharkhand",
                        "Karnataka",
                        "Kerala",
                        "Madhya Pradesh",
                        "Maharashtra",
                        "Manipur",
                        "Meghalaya",
                        "Mizoram",
                        "Nagaland",
                        "Odisha",
                        "Punjab",
                        "Rajasthan",
                        "Sikkim",
                        "Tamil Nadu",
                        "Telangana",
                        "Tripura",
                        "Uttar Pradesh",
                        "Uttarakhand",
                        "West Bengal",
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (value) {},
                  isExpanded: true,
                  menuMaxHeight: 250,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Locality"),
                  items:
                      ["All", "Urban", "Rural", "Suburban"].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (value) {},
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Category"),
                  items:
                      [
                        "All",
                        "Technology",
                        "Legal",
                        "Safety",
                        "Empowerment",
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (value) {},
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: "Min Members"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: Colors.pink, // Pink background
                foregroundColor: Colors.white, // White text
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                // Apply filter logic
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.pink, // Pink background
                foregroundColor: Colors.white, // White text
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Apply",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  //-----------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  child: Center(child: Lottie.asset('assets/pic1.json')),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular communities",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_alt, size: 30),
                      onPressed: _showFilterDialog,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: hackathons.length,
                    itemBuilder: (context, index) {
                      final hackathon = hackathons[index];
                      return Card(
                        color: const Color.fromARGB(255, 250, 244, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.network(
                                hackathon['image'],
                                fit: BoxFit.cover,
                                height: 120,
                                width: double.infinity,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hackathon['title'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    hackathon['location'],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.group,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "${hackathon['Members']} members",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.event,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "3 activity in a week",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => AboutCommunityPage(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.pink,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      side: BorderSide(color: Colors.pink),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 8,
                                      ),
                                    ),
                                    child: Text(
                                      "See community",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
