import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/widgets.dart';
import 'package:flutter_flexdiet/firebase_firestore.dart';
import 'package:flutter_flexdiet/models/final_models/client.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImagePickerService {
  Future<String?> seleccionarImagen(
      BuildContext context, ImageSource source, firebase.User? user) async {
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
        final url = uploadUserFirebase(imagen, user);
        return url;
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

  Future<String?> uploadUserFirebase(XFile? imagen, firebase.User? user) async {
    if (imagen == null) throw Exception('No hay ninguna imagen seleccionada');
    if (user == null) throw Exception('El usuario no se encuentra correctamente registrado');

    final client = await Client.getClient(user.uid);

    final supabase = Supabase.instance.client;

    File file = File(imagen.path);

    try {
      final response = await supabase.storage
          .from('FlexDiet')
          .upload('${user.uid}/${imagen.name}', file);

      final url = supabase.storage
          .from('FlexDiet')
          .getPublicUrl('${user.uid}/${imagen.name}');

      await FirestoreService.firestore
          .collection('clients')
          .doc(client.id)
          .set({'image': url}, SetOptions(merge: true));

      print('Imagen subida con éxito: $url');

      return url;
    } catch (e) {
      print('Error al subir imagen: $e');
    }
    return null;
  }
}
