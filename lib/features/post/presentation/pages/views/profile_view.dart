import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/features/post/presentation/blocs/post_bloc.dart';

class ItemOfPost extends StatelessWidget {
  const ItemOfPost({
    Key? key,
    required this.index,
    required this.context,
    required this.postBloc,
  }) : super(key: key);

  final int index;
  final BuildContext context;
  final PostBloc postBloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onLongPress: () {},
          child: CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            imageUrl: postBloc.state.posts?[index].postImage ?? ' ',
            placeholder: (context, url) => Container(
              color: Colors.grey,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Text(
          postBloc.state.posts?[index].caption ?? ' ',
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
