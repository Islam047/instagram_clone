import 'package:flutter/material.dart';
import 'package:instagram_clone/features/post/presentation/blocs/post_bloc.dart';

void showPicker(context,PostBloc bloc) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () {
                    bloc.add(const GetImageFromGalleryEvent());
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  bloc.add(const GetImageFromCameraEvent());
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      });
}
