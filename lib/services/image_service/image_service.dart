import 'package:flutter/widgets.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  Future<XFile?> seleccionarImagen(
      BuildContext context, ImageSource source) async {
    PermissionStatus status;
    if (source == ImageSource.gallery) {
      status = await Permission.photos.request();
    } else {
      status = await Permission.camera.request();
    }
    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      try {
        final XFile? imagen = await picker.pickImage(source: source);
        return imagen;
      } catch (e) {
        if (context.mounted) {
          showToast(context, 'Error al seleccionar imagen',
              toastType: ToastType.error);
        }

        return null;
      }
    } else {
      if (context.mounted) {
        showToast(
            context, 'No se ha concedido permiso para acceder a la galería',
            toastType: ToastType.error);
      }
      return null;
    }
  }
}
