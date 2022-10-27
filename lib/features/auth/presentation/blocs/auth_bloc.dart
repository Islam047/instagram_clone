import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/usecase/params/no_params.dart';
import 'package:instagram_clone/core/util/checking.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';
import 'package:instagram_clone/features/auth/domain/usecases/delete_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/follow_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/load_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/params/follow_params.dart';
import 'package:instagram_clone/features/auth/domain/usecases/params/search_params.dart';
import 'package:instagram_clone/features/auth/domain/usecases/params/sign_in_params.dart';
import 'package:instagram_clone/features/auth/domain/usecases/params/sign_up_params.dart';
import 'package:instagram_clone/features/auth/domain/usecases/params/update_user_photo_params.dart';
import 'package:instagram_clone/features/auth/domain/usecases/search_users_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/sign_in_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/sign_out_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/sign_up_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/unfollow_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/update_user_photo_usecase.dart';
import 'package:instagram_clone/features/post/presentation/blocs/post_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthOverviewState> {
  final SignUpUserUseCase signUpUserUseCase;
  final SignInUserUseCase signInUserUseCase;
  final SignOutUserUseCase signOutUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;
  final FollowUserUseCase followUserUseCase;
  final LoadUserUseCase loadUserUseCase;
  final SearchUsersUseCase searchUsersUseCase;
  final UnfollowUserUseCase unfollowUserUseCase;
  final UpdateUserPhotoUserUseCase updateUserPhotoUserUseCase;

   AuthBloc({
    required this.signUpUserUseCase,
    required this.signInUserUseCase,
    required this.signOutUserUseCase,
    required this.deleteUserUseCase,
    required this.updateUserPhotoUserUseCase,
    required this.unfollowUserUseCase,
    required this.searchUsersUseCase,
    required this.loadUserUseCase,
    required this.followUserUseCase,
  }) : super(const AuthOverviewState()) {
    on<SignUpUserEvent>(signUp);
    on<SignInUserEvent>(signIn);
    on<SignOutUserEvent>(signOut);
    on<DeleteUserEvent>(deleteUser);
    on<FollowUserEvent>(followUser);
    on<LoadUserEvent>(loadUser);
    on<SearchUsersEvent>(searchUsers);
    on<UnfollowUserEvent>(unfollowUsers);
    on<UpdateUserPhotoEvent>(updateUserPhoto);
  }
  void signUp(SignUpUserEvent event, Emitter<AuthOverviewState> emit) async {
    bool next = true;
    if(event.confirmPassword == event.password) {
      Checking.emailChecking(event.email.trim()).fold((failure) {
        next = false;
        emit(state.copyWith(status: () => AuthOverviewStatus.failure,error: () => "Incorrect email"));
      }, (result) => next = true);
    } else {
      return;
    }

    if(next) {
      Checking.passwordChecking(event.password.trim()).fold((failure) {
        next = false;
        emit(state.copyWith(status: () => AuthOverviewStatus.failure,error: () => "Password should contain at least one sign one number and at least one capital letter "));
      }, (result) => next = true);
    } else {
      return;
    }

    if(next) {
      Checking.passwordChecking(event.confirmPassword.trim()).fold((failure) {
        next = false;
        emit(state.copyWith(status: () => AuthOverviewStatus.failure,error: () => "Incorrect Confirm Password"));
      }, (result) => next = true);
    } else {
      return;
    }

    if(next) {
      Checking.nameChecking(event.fullName.trim()).fold((failure) {
        next = false;
        emit(state.copyWith(status: () => AuthOverviewStatus.failure,error: () => "Incorrect FullName"));
      }, (result) => next = true);
    } else {
      return;
    }

    if(next) {
      emit(state.copyWith(status: () => AuthOverviewStatus.loading));
    } else {
      return;
    }

    final failureOrSignUp = await signUpUserUseCase(SignUpParams(fullName: event.fullName.trim(), email: event.email.trim(), password: event.password.trim(), confirmPassword: event.confirmPassword.trim(),),);
    failureOrSignUp.fold(
        (failure) => emit(state.copyWith(status:() => AuthOverviewStatus.failure,error: () => "Sign Up Error")),
        (result) => emit(state.copyWith(status: () => AuthOverviewStatus.success)),
    );
  }

  void signIn(SignInUserEvent event, Emitter<AuthOverviewState> emit) async {
    bool next = true;

    Checking.emailChecking(event.email.trim()).fold((failure) {
      next = false;
      emit(state.copyWith(status: () => AuthOverviewStatus.failure,error: () => "Incorrect email"));
    }, (result) => next = true);


    if(next) {
      Checking.passwordChecking(event.password.trim()).fold((failure) {
        next = false;
        emit(state.copyWith(status: () => AuthOverviewStatus.failure,error: () => "Incorrect Password"));
      }, (result) => next = true);
    } else {
      return;
    }

    if(next) {
      emit(state.copyWith(status: () => AuthOverviewStatus.loading));
    } else {
      return;
    }

    final failureOrSignIn = await signInUserUseCase(SignInParams(email: event.email.trim(), password: event.password.trim(),),);
    failureOrSignIn.fold(
          (failure) => emit(state.copyWith(status:() => AuthOverviewStatus.failure,error: () => "Sign In Error")),
          (result) => emit(state.copyWith(status: () => AuthOverviewStatus.success)),
    );
  }

  void signOut(SignOutUserEvent event, Emitter<AuthOverviewState> emit) async {
    emit(state.copyWith(status:() => AuthOverviewStatus.loading));

    final failureOrSignOut = await signOutUserUseCase(NoParams());
    failureOrSignOut.fold(
          (failure) => emit(state.copyWith(status:() => AuthOverviewStatus.failure,error: () => "Sign Out Error")),
          (result) => emit(state.copyWith(status: () => AuthOverviewStatus.signOut)),
    );
  }

  void deleteUser(DeleteUserEvent event, Emitter<AuthOverviewState> emit) async {
    emit(state.copyWith(status:() => AuthOverviewStatus.loading));

    final failureOrDeleteUser = await deleteUserUseCase(NoParams());
    failureOrDeleteUser.fold(
          (failure) => emit(state.copyWith(status:() => AuthOverviewStatus.failure,error: () => "Delete User Error")),
          (result) => emit(state.copyWith(status: () => AuthOverviewStatus.success)),
    );
  }

  void followUser(FollowUserEvent event, Emitter<AuthOverviewState> emit) async {

    final failureOrFollowUser = await followUserUseCase(FollowParams(user: event.user));
    failureOrFollowUser.fold(
          (failure) => emit(state.copyWith(status:() => AuthOverviewStatus.failure,error: () => "Follow User Error")),
          (result) {
            emit(state.copyWith(status: () => AuthOverviewStatus.following,user: () => result));
            event.context.read<PostBloc>().add(const LoadFeedsEvent());
          },
    );
  }

  void loadUser(LoadUserEvent event, Emitter<AuthOverviewState> emit) async {
    emit(state.copyWith(status:() => AuthOverviewStatus.loading));

    final failureOrLoadUser = await loadUserUseCase(NoParams());
    failureOrLoadUser.fold(
          (failure) => emit(state.copyWith(status:() => AuthOverviewStatus.failure,error: () => "Load User Error")),
          (result) => emit(state.copyWith(status: () => AuthOverviewStatus.success,user: () => result)),
    );
  }

  void searchUsers(SearchUsersEvent event, Emitter<AuthOverviewState> emit) async {
    emit(state.copyWith(status:() => AuthOverviewStatus.loading));

    final failureOrSearchUsers = await searchUsersUseCase(SearchParams(keyword: event.keyword.trim()));
    failureOrSearchUsers.fold(
          (failure) => emit(state.copyWith(status:() => AuthOverviewStatus.failure,error: () => "Search User Error")),
          (result) => emit(state.copyWith(status: () => AuthOverviewStatus.success,users: () => result)),
    );
  }

  void unfollowUsers(UnfollowUserEvent event, Emitter<AuthOverviewState> emit) async {

    final failureOrUnfollowUser = await unfollowUserUseCase(FollowParams(user: event.user));
    failureOrUnfollowUser.fold(
          (failure) => emit(state.copyWith(status:() => AuthOverviewStatus.failure,error: () => "UnFollow User Error")),
          (result) { emit(state.copyWith(status: () => AuthOverviewStatus.following,user: () => result));
          event.context.read<PostBloc>().add(const LoadFeedsEvent());
          }

    );

  }

  void updateUserPhoto(UpdateUserPhotoEvent event, Emitter<AuthOverviewState> emit) async {

    emit(state.copyWith(status:() => AuthOverviewStatus.loading));

    final failureOrUpdateUserPhoto = await updateUserPhotoUserUseCase(UpdateUserPhotoParams(image: event.file));
    failureOrUpdateUserPhoto.fold(
          (failure) => emit(state.copyWith(status:() => AuthOverviewStatus.failure,error: () => "Update User Error")),
          (result) => emit(state.copyWith(status: () => AuthOverviewStatus.success,user: () => result)),
    );
  }
}
