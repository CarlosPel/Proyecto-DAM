import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/post.dart';
import 'package:flutter_application_1/utilities/req_service.dart';

class CommentWidget extends StatefulWidget {
  final Post comment;
  final void Function(Post) onPressedIcon;

  const CommentWidget({
    super.key,
    required this.comment,
    required this.onPressedIcon,
  });

  @override
  CommentWidgetState createState() => CommentWidgetState();
}

class CommentWidgetState extends State<CommentWidget> {
  bool _isExpanded = false;
  List<dynamic>? _subComments; // ⬅️ Guarda comentarios hijos

  // Método público para refrescar subcomentarios
  Future<void> refreshSubComments() async {
    final fetched = await fetchComments(widget.comment.id!);
    if (mounted) {
      setState(() {
        _subComments = fetched;
      });
    }
  }

  void _toggleExpanded() async {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    // Solo cargar si se expande y aún no hay comentarios
    if (_isExpanded && _subComments == null) {
      await refreshSubComments();
    }
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
                title: Text(comment.user ?? ''),
                subtitle: Text(comment.content),
                trailing: IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () => widget.onPressedIcon(comment),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: _subComments == null
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _subComments!.length,
                        itemBuilder: (context, index) {
                          final sub = _subComments![index];
                          return CommentWidget(
                            key: ValueKey(sub['id_post']),
                            comment: Post(
                              id: sub['id_post'],
                              content: sub['content'],
                              user: sub['user_name'],
                              parentPostId: sub['parent_post'],
                            ),
                            onPressedIcon: widget.onPressedIcon,
                          );
                        },
                      ),
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
