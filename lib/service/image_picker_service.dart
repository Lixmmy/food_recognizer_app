import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  Future<List<String>?> pickImage() async {
    try{
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();

      return images.map((image) => image.path).toList();
    } catch (e) {
     return null;
    }
  }
}