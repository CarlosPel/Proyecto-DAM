import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/post.dart';
import 'package:flutter_application_1/utilities/req_service.dart';

class CommentWidget extends StatefulWidget {
  final Post comment;
  final int? referencedCommentId;
  final void Function(Post) onPressedIcon;
  final VoidCallback? onTap;
  final bool isExpanded;

  const CommentWidget({
    super.key,
    required this.comment,
    this.referencedCommentId,
    required this.onPressedIcon,
    this.onTap,
    this.isExpanded = false,
  });

  @override
  CommentWidgetState createState() => CommentWidgetState();
}

class CommentWidgetState extends State<CommentWidget> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Post comment = widget.comment;
    return Card(
      child: InkWell(
        onTap: _toggleExpanded,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(comment.user!),
                subtitle: Text(comment.content),
                trailing: IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () => widget.onPressedIcon(widget.comment),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: FutureBuilder<List<dynamic>>(
                    future: fetchComments(comment.id!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        final comments = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final subComment = comments[index];
                            return CommentWidget(
                              comment: Post(
                                id: subComment['id_post'],
                                content: subComment['content'],
                                user: subComment['user_name'],
                                parentPostId: subComment['parent_post'],
                              ),
                              onPressedIcon: widget.onPressedIcon,
                            );
                          },
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
