import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_flexdiet/widgets/custom_toast.dart';
import 'package:intl/intl.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteRequest(String documentId) async {
    try {
      await _firestore
          .collection('password_reset_logs')
          .doc(documentId)
          .delete();
      if (mounted) {
        showToast(context, "Historial eliminado correctamente",
            toastType: ToastType.success);
      }
    } catch (e) {
      if (mounted) {
        showToast(context, "Error al eliminar el historial",
            toastType: ToastType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Solicitudes')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('password_reset_logs')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('No hay solicitudes en el historial.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final document = snapshot.data!.docs[index];
              final email = document['email'] as String? ?? 'N/A';
              final timestamp =
                  document['timestamp'] as Timestamp? ?? Timestamp.now();
              String formattedDate =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp.toDate());

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Email: $email'),
                  subtitle: Text('Fecha: $formattedDate'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteRequest(document.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
