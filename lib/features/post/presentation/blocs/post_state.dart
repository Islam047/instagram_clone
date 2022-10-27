part of 'post_bloc.dart';

enum PostOverviewStatus { initial, loading, success, failure,done,image }

class PostOverviewState extends Equatable {
  const PostOverviewState({
    this.status = PostOverviewStatus.initial,
    this.feeds = const [],
    this.posts = const [],
    this.likes = const [],
    this.post,
    this.liked,
    this.image,
    this.myImage,
    this.caption,
    this.page,
  });

  final PostOverviewStatus status;
  final List<Post>? feeds;
  final List<Post>? posts;
  final List<Post>? likes;
  final Post? post;
  final bool? liked;
  final File? image;
  final File? myImage;
  final String? caption;
  final int? page;

  PostOverviewState copyWith({
    PostOverviewStatus Function()? status,
    List<Post> Function()? feeds,
    List<Post> Function()? posts,
    List<Post> Function()? likes,
    Post Function()? post,
    bool? Function()? liked,
    File? Function()? image,
    File? Function()? myImage,
    String? Function()? caption,
    int? Function()? page,
  }) {
    return PostOverviewState(
      status: status != null ? status() : this.status,
      feeds: feeds != null ? feeds() : this.feeds,
      posts: posts != null ? posts() : this.posts,
      likes: likes != null ? likes() : this.likes,
      post: post != null ? post() : this.post,
      liked: liked != null ? liked() : this.liked,
      image: image != null ? image() : this.image,
      myImage: myImage != null ? myImage() : this.myImage,
      caption: caption != null ? caption() : this.caption,
      page: page != null ? page() : this.page,
    );
  }

  @override
  List<Object?> get props => [status, feeds, posts, likes, post, liked, image, caption, page,myImage];
}
