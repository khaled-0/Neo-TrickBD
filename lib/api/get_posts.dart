import 'package:html/parser.dart';

import '../models/post_model.dart';
import 'dio.dart';

Future<List<PostItemModel>> getPosts(
    {String? authorId, required int page}) async {
  final response = parse(
    (await dio.get("/page/$page")).data,
  );

  var recentPostsUl =
      (response.body?.querySelectorAll(".rpul").last)?.querySelectorAll("li");

  List<PostItemModel> recentPosts = List.empty(growable: true);

  recentPostsUl?.forEach((element) {
    var url = element.querySelector("a")?.attributes["href"]?.trim();
    var title = element.querySelector("a")?.text.trim();
    var thumbnailUrl = element.querySelector("img")?.attributes["src"]?.trim();
    var creationTime = element.querySelector("p")?.firstChild?.text?.trim();

    var commentCount = element.querySelector("p > a")?.text.trim();
    commentCount = commentCount?.replaceAll(RegExp(r'[^0-9]'), '');

    recentPosts.add(PostItemModel(
      url: url ?? "null",
      title: title ?? "null",
      thumbnailUrl: thumbnailUrl ?? "null",
      creationTime: creationTime,
      commentCount: int.tryParse(commentCount ?? "") ?? 0,
    ));
  });

  return recentPosts;
}
