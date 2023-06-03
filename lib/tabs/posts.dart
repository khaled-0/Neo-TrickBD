import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:neo_trickbd/components/post_item_view.dart';
import 'package:neo_trickbd/views/post.dart';
import 'package:skeletons/skeletons.dart';

import '../dio.dart';
import '../models/post_model.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  Future<List<PostItemModel>> getPosts({required int page}) async {
    final response = parse(
      (await dio.get("/page/$page")).data,
    );

    var recentPostsUl =
        (response.body?.querySelectorAll(".rpul").last)?.querySelectorAll("li");

    List<PostItemModel> recentPosts = List.empty(growable: true);

    recentPostsUl?.forEach((element) {
      var url = element.querySelector("a")?.attributes["href"]?.trim();
      var title = element.querySelector("a")?.text.trim();
      var thumbnailUrl =
          element.querySelector("img")?.attributes["src"]?.trim();
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

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts>
    with AutomaticKeepAliveClientMixin<Posts> {
  final List<PostItemModel> posts = List.empty(growable: true);
  int page = 0;
  String? statusMessage;

  void fetchMorePosts() {
    page++;
    setState(() => statusMessage = null);
    widget.getPosts(page: page).then((value) {
      for (var element in value) {
        if (!posts.contains(element)) posts.add(element);
      }

      setState(() => statusMessage = null);
    }).onError((error, stackTrace) {
      page--;
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() => statusMessage = error.toString());
      });
    });
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (notification.metrics.extentAfter < posts.length / 3) {
        if (statusMessage == null) fetchMorePosts();
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
    super.build(context);
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: RefreshIndicator(
        onRefresh: () async => setState(() {
          page = 0;
          posts.clear();
          fetchMorePosts();
        }),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: posts.length + 1,
          itemBuilder: (context, index) {
            if (index == posts.length) {
              if (statusMessage == null) {
                //Skeleton Loader
                return Column(
                  children: List.filled(
                    8,
                    SkeletonListTile(
                      hasSubtitle: true,
                      leadingStyle:
                          const SkeletonAvatarStyle(height: 96, width: 96),
                      subtitleStyle:
                          const SkeletonLineStyle(randomLength: true),
                      padding: const EdgeInsets.all(2),
                    ),
                  ),
                );
              }

              //TODO Prettify this error box
              return Row(
                children: [
                  Expanded(child: Text(statusMessage ?? "Null")),
                  TextButton(
                      onPressed: fetchMorePosts, child: const Text("RETRY"))
                ],
              );
            }

            PostItemModel post = posts[index];
            return Padding(
              padding: const EdgeInsets.only(top: 1.75, bottom: 1.75),
              child: PostItemView(
                post: post,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Post(postItemModel: post),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
