import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/base_usecase.dart';
import 'package:instagram_clone/core/usecase/params/no_params.dart';
import 'package:instagram_clone/features/post/domain/repositories/post_repository.dart';

class GetImageFromGalleryUseCase extends UseCase<File?, NoParams> {
  PostRepository postRepository;
  GetImageFromGalleryUseCase(this.postRepository);

  @override
  Future<Either<Failure, File?>> call(NoParams params) async {
    return await postRepository.getImageFromGallery();
  }
}