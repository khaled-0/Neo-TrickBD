class PostItemModel {
  String thumbnailUrl;
  String title;
  String url;

  PostItemModel(
      {required this.thumbnailUrl, required this.title, required this.url});

  @override
  bool operator ==(Object other) {
    return (other is PostItemModel && other.url == url);
  }

  @override
  int get hashCode => url.hashCode;
}

class PostModel extends PostItemModel {
  String? body;

  String? authorName;
  String? authorAvatarUrl;
  String? authorPageUrl;

  PostModel({
    required PostItemModel postItemModel,
    this.body,
    this.authorAvatarUrl,
    this.authorName,
    this.authorPageUrl,
  }) : super(
            title: postItemModel.title,
            url: postItemModel.url,
            thumbnailUrl: postItemModel.thumbnailUrl);
}
