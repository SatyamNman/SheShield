import 'package:flutter/material.dart';

class DiscussionsPage extends StatefulWidget {
  const DiscussionsPage({super.key});

  @override
  State<DiscussionsPage> createState() => _DiscussionsPageState();
}

class _DiscussionsPageState extends State<DiscussionsPage> {
  final List<DiscussionPostData> _posts = [
    DiscussionPostData(
      username: 'Priya',
      time: '9:41',
      content:
          'Have you ever felt unsafe walking home at night? What safety measures do you take?',
      likes: '40.8K',
      comments: '1.3K',
      isPinned: true,
      imageUrl:
          'https://media.istockphoto.com/id/1269099595/photo/one-young-alone-woman-in-dress-walking-on-sidewalk-through-dark-park-to-home-in-summer-black.jpg?s=612x612&w=0&k=20&c=xlqN1x-LHulwE9uY8gc22dqcnbxaPKMpDmLn_Nb0AoQ=',
      upvotes: 124,
      downvotes: 5,
      userVote: 0, // 0 = no vote, 1 = upvote, -1 = downvote
    ),
    DiscussionPostData(
      username: 'Ananya',
      time: 'Today',
      content:
          'In today\'s digital age, we need to be careful about sharing location data. Always check app permissions!',
      likes: '35.2K',
      comments: '892',
      imageUrl: 'https://images.unsplash.com/photo-1493612276216-ee3925520721',
      upvotes: 98,
      downvotes: 2,
      userVote: 0,
    ),
    DiscussionPostData(
      username: 'Meera',
      time: '22h',
      content:
          'The safety apps developed by women in Bangalore are really helpful. Has anyone tried them?',
      likes: '28.4K',
      comments: '756',
      imageUrl: 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c',
      upvotes: 76,
      downvotes: 1,
      userVote: 0,
    ),
  ];

  void _addNewPost(String content, String? imageUrl) {
    setState(() {
      _posts.insert(
        0,
        DiscussionPostData(
          username: 'You',
          time: 'Now',
          content: content,
          likes: '0',
          comments: '0',
          upvotes: 0,
          downvotes: 0,
          userVote: 0,
          imageUrl: imageUrl,
        ),
      );
    });
  }

  void _handleVote(int index, int voteType) {
    setState(() {
      final post = _posts[index];

      // Remove previous vote if exists
      if (post.userVote == 1) {
        post.upvotes--;
      } else if (post.userVote == -1) {
        post.downvotes--;
      }

      // Add new vote
      if (post.userVote == voteType) {
        // Tapping the same vote button again removes the vote
        post.userVote = 0;
      } else {
        post.userVote = voteType;
        if (voteType == 1) {
          post.upvotes++;
        } else {
          post.downvotes++;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Discussions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE91E63),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: DiscussionPost(
              data: post,
              onUpvote: () => _handleVote(index, 1),
              onDownvote: () => _handleVote(index, -1),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePostDialog(context);
        },
        backgroundColor: const Color(0xFFE91E63),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    String? _imageUrl;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'What would you like to discuss?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged:
                    (value) => _imageUrl = value.isNotEmpty ? value : null,
                decoration: const InputDecoration(
                  hintText: 'Image URL (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
              ),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  _addNewPost(_controller.text, _imageUrl);
                  Navigator.pop(context);
                }
              },
              child: const Text('Post', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

class DiscussionPostData {
  final String username;
  final String time;
  final String content;
  final String likes;
  final String comments;
  final bool isPinned;
  final String? imageUrl;
  int upvotes;
  int downvotes;
  int userVote; // 0 = no vote, 1 = upvote, -1 = downvote

  DiscussionPostData({
    required this.username,
    required this.time,
    required this.content,
    required this.likes,
    required this.comments,
    this.isPinned = false,
    this.imageUrl,
    required this.upvotes,
    required this.downvotes,
    required this.userVote,
  });
}

class DiscussionPost extends StatelessWidget {
  final DiscussionPostData data;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;

  const DiscussionPost({
    super.key,
    required this.data,
    required this.onUpvote,
    required this.onDownvote,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.isPinned)
              const Row(
                children: [
                  Icon(Icons.push_pin, size: 16, color: Colors.pink),
                  SizedBox(width: 4),
                  Text('Pinned', style: TextStyle(color: Colors.pink)),
                ],
              ),
            if (data.isPinned) const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.pink[100],
                  child: Text(
                    data.username[0],
                    style: const TextStyle(color: Colors.pink),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      data.time,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              data.content,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
            if (data.imageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  data.imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                // Upvote button
                IconButton(
                  icon: Icon(
                    data.userVote == 1
                        ? Icons.arrow_upward
                        : Icons.arrow_upward_outlined,
                    color: data.userVote == 1 ? Colors.green : Colors.grey[600],
                  ),
                  onPressed: onUpvote,
                ),
                Text(
                  data.upvotes.toString(),
                  style: TextStyle(color: Colors.grey[600]),
                ),

                // Downvote button
                IconButton(
                  icon: Icon(
                    data.userVote == -1
                        ? Icons.arrow_downward
                        : Icons.arrow_downward_outlined,
                    color: data.userVote == -1 ? Colors.red : Colors.grey[600],
                  ),
                  onPressed: onDownvote,
                ),
                Text(
                  data.downvotes.toString(),
                  style: TextStyle(color: Colors.grey[600]),
                ),

                const Spacer(),

                // Comments
                Icon(Icons.comment_outlined, color: Colors.grey[600], size: 20),
                const SizedBox(width: 4),
                Text(data.comments, style: TextStyle(color: Colors.grey[600])),

                const SizedBox(width: 16),

                // Share
                Icon(Icons.share_outlined, color: Colors.grey[600], size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
