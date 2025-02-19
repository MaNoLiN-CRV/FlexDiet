import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  Future<XFile?> seleccionarImagen(ImageSource source) async {
    PermissionStatus status;
    if (source == ImageSource.gallery) {
      status = await Permission.photos.request();
    } else {
      status = await Permission.camera.request();
    }
    if(status.isGranted) {
      final ImagePicker picker = ImagePicker();
    try {
      final XFile? imagen = await picker.pickImage(source: source);
      return imagen;
    } catch (e) {
      throw Exception('Error al intentar acceder a la galeria');
    }
    } else {
      throw Exception('Error Premisos denegados');
    }
    
  }
}