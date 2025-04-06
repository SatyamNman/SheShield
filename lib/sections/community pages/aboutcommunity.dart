import 'package:flutter/material.dart';
import 'package:sheshield/sections/community%20pages/discussions.dart';

class AboutCommunityPage extends StatefulWidget {
  const AboutCommunityPage({super.key});

  @override
  State<AboutCommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<AboutCommunityPage> {
  bool isSaved = false;
  bool hasJoined = false;
  int memberCount = 23500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: isSaved ? Colors.pink : Colors.black,
            ),
            onPressed: () {
              setState(() {
                isSaved = !isSaved;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isSaved ? 'Community saved!' : 'Removed from saved',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Community Banner with Avatar
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://img.freepik.com/free-vector/group-diverse-people-having-video-conference_74855-5231.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: 20,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.pink,
                    child: Icon(Icons.people, size: 30, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Community Name and Join Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Women Empowerment Network",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "$memberCount members • Global Community",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          hasJoined = !hasJoined;
                          if (hasJoined)
                            memberCount++;
                          else
                            memberCount--;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              hasJoined
                                  ? 'Joined community!'
                                  : 'Left community',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            hasJoined ? Colors.grey[300] : Colors.pink,
                        foregroundColor:
                            hasJoined ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: Text(hasJoined ? 'Joined' : 'Join'),
                    ),
                    if (hasJoined)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.pink, // Button background color
                          foregroundColor:
                              Colors.white, // Text (and icon) color
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20,
                            ), // Optional: rounded corners
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiscussionsPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'View Discussions',
                          style: TextStyle(
                            fontSize: 12,
                          ), // No need to set color here, it's handled by foregroundColor
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.chat_bubble_outline, 'Chat'),
                _buildActionButton(Icons.calendar_today, 'Events'),
                if (hasJoined)
                  _buildActionButton(Icons.forum, 'Discussions')
                else
                  _buildActionButton(Icons.info_outline, 'About'),
                _buildActionButton(Icons.share, 'Share'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // About Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About This Community',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Welcome to the Women Empowerment Network, a global community dedicated to supporting, uplifting, and connecting women from all walks of life. Our mission is to create a safe space for women to share experiences, gain knowledge, and build meaningful connections.",
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow(
                    Icons.people,
                    '${memberCount.formatNumber()} members',
                  ),
                  _buildInfoRow(
                    Icons.location_on,
                    'Global community with local chapters',
                  ),
                  _buildInfoRow(Icons.event, 'Weekly virtual meetups'),
                  _buildInfoRow(Icons.flag, 'Founded in 2018'),
                  const SizedBox(height: 20),
                  const Text(
                    'Community Rules',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildRuleItem('1. Be respectful and inclusive'),
                  _buildRuleItem('2. No discrimination of any kind'),
                  _buildRuleItem(
                    '3. Keep discussions relevant and constructive',
                  ),
                  _buildRuleItem('4. Respect privacy and confidentiality'),
                  const SizedBox(height: 20),
                  if (hasJoined) ...[
                    const Text(
                      'Recent Discussions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildDiscussionItem(
                      'Career growth strategies',
                      'Sarah J.',
                      '2h ago',
                      24,
                    ),
                    _buildDiscussionItem(
                      'Work-life balance tips',
                      'Maria K.',
                      '5h ago',
                      18,
                    ),
                    _buildDiscussionItem(
                      'Upcoming networking event',
                      'Community Admin',
                      '1d ago',
                      42,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 28),
          color: Colors.pink,
          onPressed: () {
            // Add functionality for each button
          },
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.pink),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(Icons.circle, size: 8, color: Colors.pink),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  Widget _buildDiscussionItem(
    String title,
    String author,
    String time,
    int comments,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.pink[100],
                  child: Text(
                    author[0],
                    style: const TextStyle(fontSize: 12, color: Colors.pink),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Posted by $author • $time',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.comment, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '$comments',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension NumberFormatting on int {
  String formatNumber() {
    if (this >= 1000) {
      double k = this / 1000;
      return '${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)}K';
    }
    return toString();
  }
}
