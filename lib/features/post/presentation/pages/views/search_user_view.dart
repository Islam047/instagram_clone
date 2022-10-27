import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';
import 'package:instagram_clone/features/auth/presentation/blocs/auth_bloc.dart';

class ItemOfUser extends StatelessWidget {
  const ItemOfUser({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.purpleAccent, width: 2)),
          padding: const EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: user.imageUrl != null
                ? CachedNetworkImage(
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    imageUrl: user.imageUrl!,
                    placeholder: (context, url) => const Image(
                        image: AssetImage("assets/images/user.png")),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : const Image(
                    image: AssetImage("assets/images/user.png"),
                    height: 40,
                    width: 40,
                  ),
          ),
        ),
        title: Text(
          user.fullName,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(user.email,
            style: const TextStyle(
              color: Colors.black54,
            )),
        trailing: Container(
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: MaterialButton(
            onPressed: () {
              if (user.followed) {
                authBloc.add(UnfollowUserEvent(user: user,context: context));
              } else {
                authBloc.add(FollowUserEvent(user: user,context: context));
              }
            },
            child: Text(
              user.followed ? "Following" : "Follow",
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
