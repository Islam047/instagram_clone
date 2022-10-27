import 'package:image_picker/image_picker.dart';

abstract class ImagePickerDataSource {
  Future<XFile?> getImageFromCamera();
  Future<XFile?> getImageFromGallery();
}

class ImagePickerDataSourceImpl implements ImagePickerDataSource {
  ImagePicker imagePicker;

  ImagePickerDataSourceImpl({required this.imagePicker});

  @override
  Future<XFile?> getImageFromCamera() async {
    XFile? image = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    return image;
  }

  @override
  Future<XFile?> getImageFromGallery() async {
    XFile? image = await imagePicker
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    return image;
  }
}