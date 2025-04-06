import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _currentTab = 0; // 0 for All, 1 for System
  List<bool> readStatus = [
    false,
    false,
    false,
    true,
    true,
  ]; // Track read status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTabButton('All', 0),
                const SizedBox(width: 16),
                _buildTabButton('System', 1),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildNotificationItem(
                  icon: Icons.search,
                  iconColor: Colors.blue,
                  title:
                      'Searcheye AI completed keywords research for www.chron.io',
                  subtitle: 'www.chron.io SEO Campaign',
                  time: '20h ago',
                  isUnread: readStatus[0],
                  onTap: () => _markAsRead(0),
                ),
                _buildNotificationItem(
                  icon: Icons.analytics,
                  iconColor: Colors.green,
                  title:
                      'Searcheye AI completed keywords research for www.chron.io',
                  subtitle: 'www.chron.io SEO Campaign',
                  time: '20h ago',
                  isUnread: readStatus[1],
                  onTap: () => _markAsRead(1),
                ),
                _buildNotificationItem(
                  icon: Icons.people,
                  iconColor: Colors.orange,
                  title:
                      'Searcheye AI added 4 new competitors to www.chron.io SEO campaign',
                  subtitle: 'www.chron.io SEO Campaign',
                  time: '20h ago',
                  isUnread: readStatus[2],
                  onTap: () => _markAsRead(2),
                ),
                _buildNotificationItem(
                  icon: Icons.track_changes,
                  iconColor: Colors.purple,
                  title:
                      'Searcheye AI set GA tracking for www.volke.com to ● Completed',
                  subtitle: 'www.volke.com',
                  time: '20h ago',
                  isUnread: readStatus[3],
                  onTap: () => _markAsRead(3),
                ),
                _buildNotificationItem(
                  icon: Icons.track_changes,
                  iconColor: Colors.purple,
                  title:
                      'Searcheye AI set GA tracking for www.volke.com to ● Completed',
                  subtitle: 'www.volke.com',
                  time: '20h ago',
                  isUnread: readStatus[4],
                  onTap: () => _markAsRead(4),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[50],
                  foregroundColor: Colors.pink,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _markAllAsRead,
                child: const Text(
                  'Mark all as read',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _currentTab == index ? Colors.pink : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: _currentTab == index ? Colors.pink : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    required bool isUnread,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight:
                                  isUnread
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.pink,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      time,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _markAsRead(int index) {
    setState(() {
      readStatus[index] = false;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < readStatus.length; i++) {
        readStatus[i] = false;
      }
    });
  }
}
