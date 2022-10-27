import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:instagram_clone/features/auth/presentation/pages/signin_page.dart';
import 'package:instagram_clone/features/post/presentation/blocs/post_bloc.dart';
import 'package:instagram_clone/features/post/presentation/pages/views/profile_view.dart';
import 'image_picker/image_picker.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postBloc = BlocProvider.of<PostBloc>(context)
      ..add(const LoadPostsEvent());
    final authBloc = BlocProvider.of<AuthBloc>(context)..add(LoadUserEvent());
    return BlocConsumer<PostBloc, PostOverviewState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              "Profile",
              style: TextStyle(
                  color: Colors.black, fontFamily: "Billabong", fontSize: 30),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    authBloc.add(SignOutUserEvent());
                  },
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: Colors.black87,
                  ))
            ],
          ),
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // #avatar
                    Stack(
                      children: [
                        BlocConsumer<AuthBloc, AuthOverviewState>(
                          listener: (context, state) {
                            if (state.status == AuthOverviewStatus.signOut) {
                              Navigator.pushReplacementNamed(
                                  context, SignInPage.id);
                            }
                          },
                          bloc: authBloc,
                          builder: (context, state) {
                            return Container(
                              height: 75,
                              width: 75,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: Colors.purpleAccent, width: 2)),
                              padding: const EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(75),
                                child: authBloc.state.user?.imageUrl == null
                                    ? const Image(
                                        image: AssetImage(
                                            "assets/images/user.png"),
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : Image(
                                        image: NetworkImage(
                                            authBloc.state.user!.imageUrl!),
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            );
                          },
                        ),
                        BlocConsumer<PostBloc, PostOverviewState>(
                          listener: (context, state) {
                            if (state.status == PostOverviewStatus.image) {
                              authBloc.add(
                                  UpdateUserPhotoEvent(file: state.image!));
                            }
                          },
                          builder: (context, state) {
                            return Container(
                              height: 77.5,
                              width: 77.5,
                              alignment: Alignment.bottomRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      showPicker(context, postBloc);
                                    },
                                    icon: const Icon(
                                      Icons.add_circle,
                                      color: Colors.purple,
                                    )),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // #name
                    Text(
                      authBloc.state.user == null
                          ? ""
                          : authBloc.state.user!.fullName.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),

                    // #email
                    Text(
                      authBloc.state.user == null
                          ? ""
                          : authBloc.state.user!.email,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    const SizedBox(height: 15),

                    // #statistics
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                text:
                                    "${postBloc.state.posts?.length ?? "0 "} ",
                                children: const [
                                  TextSpan(
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                    text: "POST",
                                  )
                                ]),
                          ),
                        ),
                        Container(
                          height: 20,
                          width: 1,
                          color: Colors.grey,
                        ),
                        BlocConsumer<AuthBloc, AuthOverviewState>(
                          listener: (context, state) {
                            if (state.status == AuthOverviewStatus.following) {
                              authBloc.add(LoadUserEvent());
                            }
                          },
                          builder: (context, state) {
                            return Expanded(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    text: authBloc.state.user == null
                                        ? "0 "
                                        : "${authBloc.state.user!.followersCount} ",
                                    children: const [
                                      TextSpan(
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                        text: "FOLLOWERS",
                                      )
                                    ]),
                              ),
                            );
                          },
                        ),
                        Container(
                          height: 20,
                          width: 1,
                          color: Colors.grey,
                        ),
                        BlocConsumer<AuthBloc, AuthOverviewState>(
                          listener: (context, state) {
                            if (state.status == AuthOverviewStatus.following) {
                              authBloc.add(LoadUserEvent());
                            }
                          },
                          builder: (context, state) {
                            return Expanded(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    text: authBloc.state.user == null
                                        ? "0 "
                                        : "${authBloc.state.user!.followingCount} ",
                                    children: const [
                                      TextSpan(
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                        text: "FOLLOWING",
                                      )
                                    ]),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // #posts
                    Expanded(
                      child: ListView.builder(
                          itemCount: postBloc.state.posts?.length,
                          itemBuilder: (context, index) {
                            return ItemOfPost(
                                index: index,
                                context: context,
                                postBloc: postBloc);
                          }),
                    ),
                  ],
                ),
              ),
              if (state.status == PostOverviewStatus.loading)
                const Center(
                  child: CircularProgressIndicator(),
                )
            ],
          ),
        );
      },
    );
  }
}
