import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:neo_trickbd/views/post.dart';

import 'dio.dart';
import 'models/post_model.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  Future<List<PostItemModel>> getPosts({required int page}) async {
    final response = parse(
      (await dio.get(getTrickBDRoute("/page/$page"))).data,
    );

    var recentPostsUl =
        (response.body?.querySelectorAll(".rpul").last)?.querySelectorAll("li");

    List<PostItemModel> recentPosts = List.empty(growable: true);

    recentPostsUl?.forEach((element) {
      var url = element.querySelector("a")?.attributes["href"];
      var title = element.querySelector("a")?.text;
      var thumbnailUrl = element.querySelector("img")?.attributes["src"];

      recentPosts.add(PostItemModel(
          url: url ?? "null",
          title: title ?? "null",
          thumbnailUrl: thumbnailUrl ?? "null"));
    });

    return recentPosts;
  }

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final List<PostItemModel> posts = List.empty(growable: true);
  int page = 0;
  String? statusMessage;

  void fetchMorePosts() {
    page++;
    widget.getPosts(page: page).then((value) {
      for (var element in value) {
        if (!posts.contains(element)) posts.add(element);
      }

      setState(() => statusMessage = null);
    }).onError((error, stackTrace) {
      page--;
      setState(() => statusMessage = error.toString());
    });
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (notification.metrics.extentAfter < posts.length / 3) {
        fetchMorePosts();
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    fetchMorePosts();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: posts.length + 1,
        itemBuilder: (context, index) {
          if (index == posts.length) {
            if (statusMessage == null) {
              return const Center(
                child: CircularProgressIndicator(), //TODO Skeleton here
              );
            }
            return Row(
              children: [
                Text(statusMessage ?? "Null"),
                const Spacer(),
                TextButton(
                    onPressed: fetchMorePosts, child: const Text("RETRY"))
              ],
            );
          }

          PostItemModel post = posts[index];
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Post(postItemModel: post),
              ),
            ),
            child: Row(
              children: [
                Image.network(
                  post.thumbnailUrl,
                  height: 148,
                  width: 148,
                ),
                Text(post.title)
              ],
            ),
          );
        },
      ),
    );
  }
}
