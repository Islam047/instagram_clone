import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/post/domain/entities/post_entity.dart';
import 'package:instagram_clone/features/post/presentation/blocs/post_bloc.dart';
import 'package:instagram_clone/features/post/presentation/pages/views/feed_view.dart';

class FeedPage extends StatelessWidget {
  final PageController pageController;

  const FeedPage({Key? key, required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // context.read<PostBloc>().add(const LoadFeedsEvent());

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Instagram",
            style: TextStyle(
                color: Colors.black, fontFamily: "Billabong", fontSize: 30),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  pageController.jumpToPage(2);
                },
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                ))
          ],
        ),
          body: Stack(
          children: [
            BlocBuilder<PostBloc, PostOverviewState>(
              builder: (context, state) {
                return ListView.builder(
                    itemCount: state.feeds?.length,
                    itemBuilder: (context, index) {
                      if (state.feeds != null) {
                        Post feed = state.feeds![index];
                        return FeedView(feed: feed);
                      } else {
                        return const SizedBox.shrink();
                      }
                    });
              },
            ),
            BlocBuilder<PostBloc, PostOverviewState>(
              builder: (context, state) {
                if (state.status == PostOverviewStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            )
          ],
        ));
  }
}

