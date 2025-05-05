import 'package:flutter/material.dart';

class CommentWidget extends ListTile {
  final String userName;
  final String text;
  final int? referencedCommentId;
  final VoidCallback onPressedIcon;

  const CommentWidget({
    super.key,
    required this.userName,
    required this.text,
    this.referencedCommentId,
    required this.onPressedIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(userName),
      subtitle: Text(text),
      trailing: IconButton(
        icon: Icon(Icons.comment),
        onPressed: () => onPressedIcon(),
      ),
    );
  }
}
