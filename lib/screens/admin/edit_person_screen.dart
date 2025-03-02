import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/models/final_models/client.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_flexdiet/widgets/custom_toast.dart';

class EditPerson extends StatefulWidget {
  final String clientId;
  const EditPerson({super.key, required this.clientId});

  @override
  State<EditPerson> createState() => _EditPersonState();
}

class _EditPersonState extends State<EditPerson> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? nameController;
  TextEditingController? kgController;
  TextEditingController? descriptionController;
  TextEditingController? heightController;
  TextEditingController?
      targetWeightController; // New controller for Target Weight
  String? sex;
  Client? client;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    try {
      final Client fetchedClient = await Client.getClient(widget.clientId);
      if (mounted) {
        setState(() {
          client = fetchedClient;
          _initializeControllers();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showToast(context, 'Cliente no encontrado: ${e.toString()}',
              toastType: ToastType.error);
          Navigator.pop(context);
        });
      }
    }
  }

  void _initializeControllers() {
    nameController = TextEditingController(text: client?.username ?? '');
    kgController =
        TextEditingController(text: client?.bodyweight?.toString() ?? '');
    descriptionController =
        TextEditingController(text: client?.description ?? '');
    heightController =
        TextEditingController(text: client?.height?.toString() ?? '');
    // Mapping from client's sex value to DropdownMenuItem values
    if (client?.sex == 'hombre') {
      sex = 'Masculino';
    } else if (client?.sex == 'mujer') {
      sex = 'Femenino';
    } else {
      sex = null; // Or a default value if appropriate
    }
  }

  @override
  void dispose() {
    nameController?.dispose();
    kgController?.dispose();
    descriptionController?.dispose();
    heightController?.dispose();
    targetWeightController?.dispose(); // Dispose of targetWeightController
    super.dispose();
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    IconData? prefixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }

  Future<void> _showDeleteDialog() async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Eliminar Cliente'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este cliente? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCELAR'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade100,
              foregroundColor: Colors.red,
            ),
            child: const Text('ELIMINAR'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final bool deleteSuccess = await Client.deleteClient(widget.clientId);
      if (deleteSuccess) {
        if (mounted) {
          showToast(context, 'Cliente eliminado correctamente',
              toastType: ToastType.error);
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          showToast(context, 'Error al eliminar el cliente',
              toastType: ToastType.error);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cliente'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Información Personal',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ).animate().fadeIn().slideX(),
                              const SizedBox(height: 16),
                              if (nameController != null)
                                _buildFormField(
                                  controller: nameController!,
                                  label: 'Nombre',
                                  prefixIcon: Icons.person,
                                  validator: (value) => value?.isEmpty ?? true
                                      ? 'Campo requerido'
                                      : null,
                                ).animate().fadeIn().slideX(),
                              if (kgController != null)
                                _buildFormField(
                                  controller: kgController!,
                                  label: 'Peso (kg)',
                                  prefixIcon: Icons.monitor_weight,
                                  keyboardType: TextInputType.number,
                                  validator: (value) =>
                                      double.tryParse(value ?? '') == null
                                          ? 'Ingrese un número válido'
                                          : null,
                                ).animate().fadeIn().slideX(),
                              if (heightController != null)
                                _buildFormField(
                                  controller: heightController!,
                                  label: 'Altura (cm)',
                                  prefixIcon: Icons.height,
                                  keyboardType: TextInputType.number,
                                  validator: (value) =>
                                      double.tryParse(value ?? '') == null
                                          ? 'Ingrese un número válido'
                                          : null,
                                ).animate().fadeIn().slideX(),
                              if (targetWeightController !=
                                  null) // Add the new form field for Target Weight
                                _buildFormField(
                                  controller: targetWeightController!,
                                  label: 'Peso Deseado (kg)',
                                  prefixIcon: Icons.flag,
                                  keyboardType: TextInputType.number,
                                  validator: (value) =>
                                      double.tryParse(value ?? '') == null
                                          ? 'Ingrese un número válido'
                                          : null,
                                ).animate().fadeIn().slideX(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detalles Adicionales',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ).animate().fadeIn().slideX(),
                              const SizedBox(height: 16),
                              if (descriptionController != null)
                                _buildFormField(
                                  controller: descriptionController!,
                                  label: 'Descripción',
                                  prefixIcon: Icons.description,
                                  maxLines: 3,
                                ).animate().fadeIn().slideX(),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Sexo',
                                  prefixIcon: const Icon(Icons.people),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                ),
                                value: sex,
                                items: ['Masculino', 'Femenino']
                                    .map((String value) =>
                                        DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        ))
                                    .toList(),
                                validator: (value) =>
                                    value == null ? 'Campo requerido' : null,
                                onChanged: (String? newValue) {
                                  setState(() => sex = newValue);
                                },
                              ).animate().fadeIn().slideX(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  // Map the selected value back to the format the backend expects.
                                  if (sex == 'Masculino') {
                                  } else if (sex == 'Femenino') {
                                  } else {
// Handle no selection or error case.
                                  }

                                  // TODO: Implement save logic.  Include `sexToSave` in the data.

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Guardando cambios...'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.save),
                              label: const Text('GUARDAR'),
                            ),
                          ),
                        ],
                      ).animate().fadeIn().slideY(),
                      const SizedBox(height: 48),
                      OutlinedButton.icon(
                        onPressed: _showDeleteDialog,
                        icon: const Icon(Icons.delete_forever),
                        label: const Text('ELIMINAR CLIENTE'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: BorderSide(color: Colors.red),
                          padding: const EdgeInsets.all(16),
                        ),
                      ).animate().fadeIn().slideY(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
