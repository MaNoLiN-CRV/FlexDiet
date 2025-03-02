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
  final ImagePicker _picker;
  final SupabaseClient _supabaseClient;

  ImagePickerService():
    _picker = ImagePicker(),
    _supabaseClient = Supabase.instance.client;

  //* Allows the user to select an image from the gallery or camera
  //* and upload it to Firebase Storage.
  // Returns the URL of the uploaded image or null if there is an error.
   Future<String?> selectImage(
      BuildContext context, ImageSource source, firebase.User? user) async {
    if (user == null) {
      showError(context, 'Usuario no autenticado');
      return null;
    }

    // Request permission according to the source
    if (!await _askForPerm(context, source)) {
      return null;
    }

    try {
      final XFile? imagen = await _picker.pickImage(source: source);
      if (imagen == null) {
        return null; // User cancelled selection
      }

      return await _saveImage(imagen, user);
    } catch (e) {
      if (context.mounted) {
        showError(context, 'Error al seleccionar imagen');
      }
      print('Error en seleccionarImagen $e');
      return null;
    }
  }

  // Request the necessary permissions according to the source of the image
  Future<bool> _askForPerm(BuildContext context, ImageSource source) async {
    final PermissionStatus status = await (source == ImageSource.gallery
        ? Permission.photos.request()
        : Permission.camera.request());

    if (!status.isGranted && context.mounted) {
      showError(
        context,
        'No se ha concedido permiso para acceder',
      );
    }

    return status.isGranted;
  }

  // Upload the selected image to Firebase Storage and update the user profile
  Future<String?> _saveImage(XFile imagen, firebase.User user) async {
    try {
      final client = await Client.getClient(user.uid);
      final String rutaArchivo = '${user.uid}/${imagen.name}';
      final File file = File(imagen.path);

      // Upload file to Supabase Storage
      await _supabaseClient.storage.from('FlexDiet').upload(rutaArchivo, file);

      // Create signed URL
      final String url = await _supabaseClient.storage
          .from('FlexDiet')
          .createSignedUrl(rutaArchivo, 60 * 60 * 24); // 24 hours

      // Update customer profile in Firestore
      await _uploadInFirebase(client.id, url);
      print('Imagen subida con éxito: $url');
      return url;
    } catch (e) {
      print('Error al subir imagen a Firebase $e');
      return null;
    }
  }

  // Update the customer profile with the new image URL
  Future<void> _uploadInFirebase(String clientId, String imageUrl) async {
    await FirestoreService.firestore
        .collection('clients')
        .doc(clientId)
        .set({'image': imageUrl}, SetOptions(merge: true));
  }

  // Displays an error message to the user
  void showError(BuildContext context, String mensaje, {ToastType toastType = ToastType.error}) {
    if (context.mounted) {
      showToast(context, mensaje, toastType: toastType);
    }
  }
}