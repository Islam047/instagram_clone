import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/post/domain/entities/post_entity.dart';
import 'package:instagram_clone/features/post/presentation/blocs/post_bloc.dart';
import 'package:instagram_clone/features/post/presentation/pages/views/likes_view.dart';

class LikesPage extends StatelessWidget {
  const LikesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     BlocProvider.of<PostBloc>(context).add(const LoadLikesEvent());
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Likes",
            style: TextStyle(
                color: Colors.black, fontFamily: "Billabong", fontSize: 30),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            BlocBuilder<PostBloc, PostOverviewState>(
              builder: (context, state) {
                return ListView.builder(
                    itemCount: state.likes?.length,
                    itemBuilder: (context, index) {
                      if (state.likes != null) {
                        Post feed = state.likes![index];
                        return LikesView(feed: feed);
                      } else {
                        return const SizedBox.shrink();
                      }
                    });
              },
            ),
            Center(
              child: BlocBuilder<PostBloc, PostOverviewState>(
                builder: (context, state) {
                  if (state.status == PostOverviewStatus.loading) {
                    return const CircularProgressIndicator();
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ));
  }
}
