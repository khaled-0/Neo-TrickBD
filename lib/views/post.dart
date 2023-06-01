import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:neo_trickbd/models/post_model.dart';
import 'package:skeletons/skeletons.dart';

import '../dio.dart';
import '../main.dart';

class Post extends StatefulWidget {
  final PostItemModel postItemModel;

  const Post({super.key, required this.postItemModel});

  Future<PostModel> getPost({required PostItemModel postItem}) async {
    final response = parse((await dio.get(postItem.url)).data);
    var postParagraphDiv =
        response.body?.querySelector(".post_paragraph")?.innerHtml;

    var likeButton = response.body?.querySelector(".trickbd-like-count");
    var likeCount = likeButton?.querySelector("span")?.text;

    var authorAvatarUrl =
        response.body?.querySelector(".avatar")?.attributes["src"];
    var authorName = response.body?.querySelector(".author-link")?.text;
    var authorRole = response.body?.querySelector(".user_role")?.text.trim();
    var authorPageUrl =
        response.body?.querySelector(".author-link")?.attributes["href"];

    PostModel postModel = PostModel(postItemModel: postItemModel);
    postModel.body = postParagraphDiv;
    postModel.likeCount = int.tryParse(likeCount ?? "0");
    postModel.authorName = authorName?.trim();
    postModel.authorAvatarUrl = authorAvatarUrl;
    postModel.authorRole =
        authorRole?.replaceFirst(authorRole[0], authorRole[0].toUpperCase());
    postModel.authorPageUrl = authorPageUrl;

    return postModel;
  }

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  late PostModel postModel;
  String? statusMessage;

  @override
  void initState() {
    super.initState();
    postModel = PostModel(postItemModel: widget.postItemModel);
    widget.getPost(postItem: widget.postItemModel).then((value) {
      statusMessage = null;
      setState(() => postModel = value);
    }).onError((error, stackTrace) {
      setState(() => statusMessage = error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(postModel.title),
        actions: [
          IconButton(
            onPressed: () => launchUrlInBrowser(postModel.url),
            icon: const Icon(Icons.open_in_browser_rounded),
          )
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Stack(
            children: [
              Hero(
                tag: postModel.thumbnailUrl,
                child: Image.network(
                  postModel.thumbnailUrl,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  height: 148,
                ),
              ),
              if (postModel.creationTime != null)
                Positioned(
                  left: 8,
                  top: 8,
                  child: Chip(
                    label: Text(
                      postModel.creationTime!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              Positioned.fill(
                bottom: 8,
                left: 8,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.thumb_up_rounded),
                      label: Text("${postModel.likeCount ?? "..."}"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.comment_rounded),
                      label: Text("${postModel.commentCount ?? "..."}"),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          alignment: Alignment.center),
                      child: const Icon(Icons.share_rounded),
                    ),
                  ],
                ),
              )
            ],
          ),

          //Post Content
          Skeleton(
            isLoading: postModel.body == null,
            skeleton: SkeletonParagraph(
              style: const SkeletonParagraphStyle(lines: 10),
            ),
            child: Html(
              data: postModel.body ?? "",
              shrinkWrap: true,
              onLinkTap: (url, context, attributes, element) async {
                launchUrlInBrowser(url);
                //TODO: Handle images/links in a menu
              },
              onImageTap: (url, context, attributes, element) async {

              },
            ),
          ),

          Divider(
            color: isDarkTheme(context) ? Colors.white10 : Colors.black12,
            height: 8,
            endIndent: 4,
            indent: 4,
          ),

          //Author Info
          Skeleton(
            isLoading: postModel.authorName == null,
            skeleton: SkeletonListTile(
              padding: const EdgeInsets.all(8),
              hasSubtitle: true,
              leadingStyle: const SkeletonAvatarStyle(height: 78, width: 78),
              titleStyle: const SkeletonLineStyle(randomLength: true),
              subtitleStyle: const SkeletonLineStyle(randomLength: true),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: postModel.authorAvatarUrl ?? "",
                          fit: BoxFit.contain,
                          placeholder: (context, url) => const SkeletonAvatar(
                            style: SkeletonAvatarStyle(height: 78, width: 78),
                          ),
                          height: 78,
                          width: 78,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            postModel.authorName.toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(postModel.authorRole.toString())
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded)
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
