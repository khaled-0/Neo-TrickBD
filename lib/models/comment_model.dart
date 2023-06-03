import 'package:html/dom.dart';

class CommentModel {
  String authorName;
  String authorAvatarUrl;
  String? authorProfileLink;
  String authorRole;

  String commentBody;
  String commentDate;

  List<CommentModel>? replies;

  CommentModel({
    required this.authorName,
    required this.authorAvatarUrl,
    this.authorProfileLink,
    required this.authorRole,
    required this.commentBody,
    required this.commentDate,
    this.replies,
  });

  factory CommentModel.parseComment(Element node) {
    var authorName =
        node.querySelector(".comment-author > .fn > .url")?.text.trim() ?? "";
    var authorProfileLink =
        node.querySelector(".comment-author > .fn > .url")?.attributes["href"];
    var authorAvatarUrl =
        node.querySelector(".comment-author > .avatar")?.attributes["src"] ??
            "";

    var authorRole = node
            .querySelector(".comment-author > .fn > .user-badge")
            ?.text
            .trim() ??
        "";
    var commentBody = node.querySelector("p")?.text.trim() ?? "";
    var commentDate =
        node.querySelector(".comment-meta > a")?.text.trim() ?? "Unknown Date";

    return CommentModel(
      authorName: authorName,
      authorAvatarUrl: authorAvatarUrl,
      authorProfileLink: authorProfileLink,
      authorRole: authorRole,
      commentBody: commentBody,
      commentDate: commentDate,
    );
  }
}
