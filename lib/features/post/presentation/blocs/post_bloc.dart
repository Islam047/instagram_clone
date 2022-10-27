import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/usecase/params/no_params.dart';
import 'package:instagram_clone/features/post/domain/entities/post_entity.dart';
import 'package:instagram_clone/features/post/domain/usecases/get_image_from_camera_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/get_image_from_gallery_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/like_post_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/load_feeds_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/load_likes_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/load_posts_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/params/like_post_params.dart';
import 'package:instagram_clone/features/post/domain/usecases/params/remove_post_params.dart';
import 'package:instagram_clone/features/post/domain/usecases/params/store_post_params.dart';
import 'package:instagram_clone/features/post/domain/usecases/remove_post_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/store_post_usecase.dart';
part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostOverviewState> {
  LikePostUseCase likePostUseCase;
  LoadFeedsUseCase loadFeedsUseCase;
  LoadLikesUseCase loadLikesUseCase;
  LoadPostsUseCase loadPostsUseCase;
  RemovePostUseCase removePostUseCase;
  StorePostUseCase storePostUseCase;
  GetImageFromCameraUseCase getImageFromCameraUseCase;
  GetImageFromGalleryUseCase getImageFromGalleryUseCase;

  PostBloc({
    required this.likePostUseCase,
    required this.loadFeedsUseCase,
    required this.loadLikesUseCase,
    required this.loadPostsUseCase,
    required this.removePostUseCase,
    required this.storePostUseCase,
    required this.getImageFromCameraUseCase,
    required this.getImageFromGalleryUseCase,
  }) : super(const PostOverviewState()) {
    on<LikePostEvent>(likePost);
    on<LoadFeedsEvent>(loadFeeds);
    on<LoadLikesEvent>(loadLikes);
    on<LoadPostsEvent>(loadPost);
    on<RemovePostEvent>(removePost);
    on<StorePostEvent>(storePost);
    on<GetImageEvent>(getImage);
    on<CancelImageEvent>(cancelImage);
    on<GetImageFromGalleryEvent>(getImageFromGallery);
    on<GetImageFromCameraEvent>(getImageFromCamera);
  }

  void getImageFromGallery(GetImageFromGalleryEvent event, Emitter<PostOverviewState> emit)async{
    final failureOrGallery = await getImageFromGalleryUseCase(NoParams());
    failureOrGallery.fold((failure) =>
        emit(state.copyWith(status: () => PostOverviewStatus.failure)),
            (result) => emit(state.copyWith( image : () => result,status: () => PostOverviewStatus.image)));

  }

  void getImageFromCamera(GetImageFromCameraEvent event, Emitter<PostOverviewState> emit)async{
    final failureOrCamera = await getImageFromCameraUseCase(NoParams());
    failureOrCamera.fold((failure) =>
        emit(state.copyWith(status: () => PostOverviewStatus.failure)),
            (result) => emit(state.copyWith( image : () => result,status: () => PostOverviewStatus.image)));
  }

  void likePost(LikePostEvent event, Emitter<PostOverviewState> emit)async {
    emit(state.copyWith(status: () => PostOverviewStatus.loading));
    final failureOrLike = await likePostUseCase(LikePostParams(post: event.post, liked: event.liked));
    failureOrLike.fold((failure) =>
        emit(state.copyWith(status: () => PostOverviewStatus.failure)),
            (result) => emit(state.copyWith(post: () => event.post, liked : () => event.liked,status: () => PostOverviewStatus.success)));
  }

  void loadFeeds(LoadFeedsEvent event, Emitter<PostOverviewState> emit) async{
    emit(state.copyWith(status: () => PostOverviewStatus.loading));
    final failureOrLike = await loadFeedsUseCase(NoParams());
    failureOrLike.fold((failure) =>
        emit(state.copyWith(status: () => PostOverviewStatus.failure)),
        (result) => emit(state.copyWith(feeds: () => result,status: () => PostOverviewStatus.success)));
  }

  void loadPost(LoadPostsEvent event, Emitter<PostOverviewState> emit) async{
    emit(state.copyWith(status: () => PostOverviewStatus.loading));
    final failureOrLoadPost = await loadPostsUseCase(NoParams());
    failureOrLoadPost.fold((failure) => emit(state.copyWith(status: () => PostOverviewStatus.failure)),
            (result) => emit(state.copyWith(posts: () => result,status: () => PostOverviewStatus.success)));
  }

  void loadLikes(LoadLikesEvent event, Emitter<PostOverviewState> emit) async{
    emit(state.copyWith(status: () => PostOverviewStatus.loading));
    final failureOrLoadLike = await loadLikesUseCase(NoParams());
    failureOrLoadLike.fold((failure) => emit(state.copyWith(status: () => PostOverviewStatus.failure)),
            (result) => emit(state.copyWith(likes: () => result,status: () => PostOverviewStatus.success)));
  }

  void removePost(RemovePostEvent event, Emitter<PostOverviewState> emit) async{
    emit(state.copyWith(status: () => PostOverviewStatus.loading));
    final failureOrRemovePost = await removePostUseCase(RemovePostParams(post: event.post));
    failureOrRemovePost.fold((failure) => emit(state.copyWith(status: () => PostOverviewStatus.failure)),
            (result) => emit(state.copyWith(post: () => event.post,status: () => PostOverviewStatus.success)));
  }

  void storePost(StorePostEvent event, Emitter<PostOverviewState> emit)async {
    emit(state.copyWith(status: () => PostOverviewStatus.loading));
    final failureOrStorePost = await storePostUseCase(StorePostParams(image: event.image, caption: event.caption));
    failureOrStorePost.fold((failure) => emit(state.copyWith(status: () => PostOverviewStatus.failure)),
            (result) {
          emit(state.copyWith(page: () => 0,status: () => PostOverviewStatus.done));
          add(CancelImageEvent());
          add(const LoadFeedsEvent());
        });
  }


  void getImage(GetImageEvent event, Emitter<PostOverviewState> emit)async {
    emit(state.copyWith(image: () => event.image));
  }

  void cancelImage(CancelImageEvent event, Emitter<PostOverviewState> emit)async {
    emit(state.copyWith(image: () => null));

  }
}
