import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SheShieldChatApp extends StatelessWidget {
  const SheShieldChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
      theme: ThemeData(
        primaryColor: Colors.pink[400],
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  final List<Map<String, String>> stories = List.generate(
    10,
    (index) => {
      "name":
          [
            "Priya",
            "Ananya",
            "Divya",
            "Shreya",
            "Neha",
            "Kavya",
            "Isha",
            "Riya",
            "Tanvi",
            "Pooja",
          ][index],
      "image": "https://randomuser.me/api/portraits/women/${index + 1}.jpg",
    },
  );

  final List<Map<String, String>> chats = [
    {
      "name": "Aarav Sharma",
      "message": "Hey, how are you doing?",
      "time": "10:30",
      "unread": "2",
      "image": "https://randomuser.me/api/portraits/men/1.jpg",
    },
    {
      "name": "Diya Patel",
      "message": "Can we meet tomorrow?",
      "time": "09:15",
      "unread": "1",
      "image": "https://randomuser.me/api/portraits/women/2.jpg",
    },
    {
      "name": "Vihaan Gupta",
      "message": "I sent you the documents",
      "time": "Yesterday",
      "unread": "0",
      "image": "https://randomuser.me/api/portraits/men/3.jpg",
    },
    {
      "name": "Ananya Singh",
      "message": "Thanks for your help!",
      "time": "Yesterday",
      "unread": "0",
      "image": "https://randomuser.me/api/portraits/women/4.jpg",
    },
    {
      "name": "Reyansh Joshi",
      "message": "Let me know when you're free",
      "time": "Monday",
      "unread": "0",
      "image": "https://randomuser.me/api/portraits/men/5.jpg",
    },
    {
      "name": "Isha Reddy",
      "message": "Did you see the news?",
      "time": "Monday",
      "unread": "3",
      "image": "https://randomuser.me/api/portraits/women/6.jpg",
    },
    {
      "name": "Arjun Malhotra",
      "message": "The meeting is postponed",
      "time": "Sunday",
      "unread": "0",
      "image": "https://randomuser.me/api/portraits/men/7.jpg",
    },
    {
      "name": "Kavya Nair",
      "message": "Happy Birthday! 🎉",
      "time": "Saturday",
      "unread": "0",
      "image": "https://randomuser.me/api/portraits/women/8.jpg",
    },
    {
      "name": "Aditya Iyer",
      "message": "Call me when you get this",
      "time": "Friday",
      "unread": "0",
      "image": "https://randomuser.me/api/portraits/men/9.jpg",
    },
    {
      "name": "Saanvi Kapoor",
      "message": "I'll be there in 10 mins",
      "time": "Thursday",
      "unread": "0",
      "image": "https://randomuser.me/api/portraits/women/10.jpg",
    },
    {
      "name": "Rudra Chatterjee",
      "message": "Check your email please",
      "time": "Wednesday",
      "unread": "1",
      "image": "https://randomuser.me/api/portraits/men/11.jpg",
    },
    {
      "name": "Anika Desai",
      "message": "Let's catch up soon",
      "time": "Tuesday",
      "unread": "0",
      "image": "https://randomuser.me/api/portraits/women/12.jpg",
    },
    {
      "name": "Kabir Khanna",
      "message": "The package has arrived",
      "time": "Monday",
      "unread": "0",
      "image": "https://randomuser.me/api/portraits/men/13.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredChats =
        chats
            .where(
              (chat) => chat["name"]!.toLowerCase().contains(
                _searchText.toLowerCase(),
              ),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Search...",
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.black54),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Story Section
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: [
                _buildStory("Add Story", "", isAddStory: true),
                for (var story in stories)
                  _buildStory(story["name"]!, story["image"]!),
              ],
            ),
          ),
          // Chats Section
          Expanded(
            child: ListView.builder(
              itemCount: filteredChats.length,
              itemBuilder: (context, index) {
                final chat = filteredChats[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: NetworkImage(chat["image"]!),
                  ),
                  title: Text(
                    chat["name"]!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    chat["message"]!,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(chat["time"]!, style: TextStyle(color: Colors.grey)),
                      if (chat["unread"] != "0")
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.pink,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            chat["unread"]!,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    // Navigate to chat details screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ChatDetailScreen(
                              name: chat["name"]!,
                              imageUrl: chat["image"]!,
                            ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStory(String name, String imageUrl, {bool isAddStory = false}) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.pinkAccent, width: 2),
          ),
          child: ClipOval(
            child:
                isAddStory
                    ? Icon(Icons.add, size: 30, color: Colors.pinkAccent)
                    : CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) =>
                              CircularProgressIndicator(strokeWidth: 2),
                      errorWidget:
                          (context, url, error) =>
                              Icon(Icons.error, color: Colors.red),
                    ),
          ),
        ),
        SizedBox(height: 5),
        Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// Chat Detail Screen
class ChatDetailScreen extends StatelessWidget {
  final String name;
  final String imageUrl;

  const ChatDetailScreen({
    super.key,
    required this.name,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
            SizedBox(width: 10),
            Text(
              name,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: const [
                ChatBubble(text: 'Hello!', isMe: true),
                ChatBubble(text: 'Hi, how are you?', isMe: false),
                ChatBubble(text: 'I\'m good, thanks!', isMe: true),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.pink,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {},
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

// Chat Bubble Widget
class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  const ChatBubble({super.key, required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.pink[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(text, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
