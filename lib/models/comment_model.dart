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
}
