import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/post.dart';
import 'package:flutter_application_1/utilities/req_service.dart';

class CommentWidget extends StatefulWidget {
  final Post comment;
  final int? referencedCommentId;
  final VoidCallback onPressedIcon;
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
  @override
  Widget build(BuildContext context) {
    final Post comment = widget.comment;
    return Card(
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(comment.user!),
                      subtitle: Text(comment.content),
                      trailing: IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () => widget.onPressedIcon(),
                      ),
                    ),
                  ),
                  /*Icon(
                    widget.isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.black,
                  ),*/
                ],
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: FutureBuilder<List<dynamic>>(
                        future: fetchComments(comment.id!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            final comments = snapshot.data!;
                            return ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                final comment = comments[index];
                                return CommentWidget(
                                  comment: Post(
                                    id: comment['id_post'],
                                    content: comment['content'],
                                    user: comment['user_name'],
                                    parentPostId: comment['parent_post'],
                                  ),
                                  onPressedIcon: () => widget.onPressedIcon(),
                                );
                              },
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        })),
                crossFadeState: widget.isExpanded
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
