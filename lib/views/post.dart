import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:neo_trickbd/models/post_model.dart';

import '../dio.dart';

class Post extends StatefulWidget {
  final PostItemModel postItemModel;

  const Post({super.key, required this.postItemModel});

  Future<PostModel> getPost({required PostItemModel postItem}) async {
    final response =
        parse((await dio.get(postItem.url + forcedMobileThemeQuery)).data);
    var postParagraphDiv =
        response.body?.querySelector(".post_paragraph")?.innerHtml;

    PostModel postModel = PostModel(postItemModel: postItemModel);
    postModel.body = postParagraphDiv;

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
        title: Text(postModel.title.trim()),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Html(
          data: postModel.body ?? "...",
          shrinkWrap: true,
          onLinkTap: (url, context, attributes, element) async {
            launchUrlInBrowser(url);
          },
        ),
      ),
    );
  }
}
