import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/util/utility.dart';
import 'package:instagram_clone/features/post/domain/entities/post_entity.dart';
import 'package:instagram_clone/features/post/presentation/blocs/post_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LikesView extends StatelessWidget {
  const LikesView({
    Key? key,
    required this.feed,
  }) : super(key: key);

  final Post feed;

  @override
  Widget build(BuildContext context) {
    final PostBloc postBloc = context.read<PostBloc>();

    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: feed.imageUser != null
                  ? CachedNetworkImage(
                height: 40,
                imageUrl: feed.imageUser!,
                placeholder: (context, url) =>
                const Image(
                    image: AssetImage(
                        "assets/images/user.png")),
                errorWidget: (context, url, error) =>
                const Icon(Icons.error),
              )
                  : const Image(
                image: AssetImage(
                    "assets/images/user.png"),
                height: 40,
              ),
            ),
            title: Text(
              feed.fullName,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
                Utils.getMonthDayYear(feed.createdDate),
                style: const TextStyle(color: Colors.black)),
            trailing: feed.isMine
                ? IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.black,
                size: 30,
              ),
            )
                : const SizedBox.shrink(),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              CachedNetworkImage(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                imageUrl: feed.postImage,
                placeholder: (context, url) => Container(
                  color: Colors.grey,
                ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.error),
              ),

            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  postBloc.add(LikePostEvent(feed, !feed.isLiked));
                },
                icon: Icon(
                  feed.isLiked ? Icons.favorite : Icons.favorite_outline,
                  color: feed.isLiked ? Colors.red : Colors.black,
                  size: 27.5,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.paperplane_fill,
                  color: Colors.black,
                  size: 27.5,
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: 5, horizontal: 15),
            child: Text(
              feed.caption,
              style: const TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
