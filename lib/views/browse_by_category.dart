import 'package:flutter/material.dart';
import 'package:neo_trickbd/components/post_item_view.dart';
import 'package:neo_trickbd/models/category_model.dart';
import 'package:neo_trickbd/views/post_view.dart';
import 'package:skeletons/skeletons.dart';

import '../api/get_posts.dart';
import '../models/post_model.dart';

class BrowseByCategory extends StatefulWidget {
  final CategoryModel category;

  const BrowseByCategory({super.key, required this.category});

  @override
  State<BrowseByCategory> createState() => _BrowseByCategoryState();
}

class _BrowseByCategoryState extends State<BrowseByCategory> {
  final List<PostItemModel> posts = List.empty(growable: true);
  int page = 0;
  String? statusMessage;

  void fetchMorePosts() {
    page++;
    setState(() => statusMessage = null);
    getRecentPosts(prefix: widget.category.categoryUrlPrefix, page: page)
        .then((value) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts in ${widget.category.name}"),
        scrolledUnderElevation: 0,
        leading: BackButton(onPressed: () => Navigator.maybePop(context)),
      ),
      body: NotificationListener<ScrollNotification>(
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
                      builder: (context) => PostView(postItemModel: post),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
