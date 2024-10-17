import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  final Color color; // Add color parameter

  const CommentCard({super.key, required this.snap, required this.color}); // Accept color in constructor

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isLiked = false; // Track if the comment is liked

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });

    if (_isLiked) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color, // Set the background color of the comment card
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap['profilePic'],
            ),
            radius: 18,
          ),
          // Reduced the left padding to bring the comment text closer to the profile picture
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0), // Reduced left padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: widget.snap['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black), // Set text color to black
                      ),
                      TextSpan(
                        text: ' ${widget.snap['text']}',
                        style: const TextStyle(color: Colors.black), // Set text color to black
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap['datePublished'].toDate(),
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.black, // Set date text color to black
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ScaleTransition(
            scale: _animation,
            child: IconButton(
              icon: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                size: 16,
                color: Colors.red, // Set icon color to black
              ),
              onPressed: _toggleLike,
            ),
          ),
        ],
      ),
    );
  }
}
