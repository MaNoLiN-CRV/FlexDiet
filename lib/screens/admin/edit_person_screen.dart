import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/models/final_models/client.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_flexdiet/widgets/custom_toast.dart'; // Assuming you have a custom toast widget

class EditPerson extends StatefulWidget {
  late Client client;
  final String clientId;
  EditPerson({super.key, required this.clientId});

  @override
  State<EditPerson> createState() => _EditPersonState();
}

class _EditPersonState extends State<EditPerson> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController kgController;
  late final TextEditingController descriptionController;
  late final TextEditingController heightController;
  String? sex;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeControllers();
  }

  void _initializeData() async {
    final Client? client = await Client.getClient(widget.clientId);
    if (client != null && mounted) {
      setState(() => widget.client = client);
    } else {
      showToast(context, 'Cliente no encontrado', toastType: ToastType.error);
      Navigator.pop(context);
    }
  }

  void _initializeControllers() {
    nameController = TextEditingController(text: widget.client.username);
    kgController =
        TextEditingController(text: widget.client.bodyweight?.toString() ?? '');
    descriptionController =
        TextEditingController(text: widget.client.description ?? '');
    heightController =
        TextEditingController(text: widget.client.height?.toString() ?? '');
    sex = widget.client.sex;
  }

  @override
  void dispose() {
    nameController.dispose();
    kgController.dispose();
    descriptionController.dispose();
    heightController.dispose();
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Cliente eliminado'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      } else {
        showToast(context, 'Error al eliminar el cliente', toastType: ToastType.error);
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
      body: SingleChildScrollView(
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
                        _buildFormField(
                          controller: nameController,
                          label: 'Nombre',
                          prefixIcon: Icons.person,
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Campo requerido' : null,
                        ).animate().fadeIn().slideX(),
                        _buildFormField(
                          controller: kgController,
                          label: 'Peso (kg)',
                          prefixIcon: Icons.monitor_weight,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              double.tryParse(value ?? '') == null
                                  ? 'Ingrese un número válido'
                                  : null,
                        ).animate().fadeIn().slideX(),
                        _buildFormField(
                          controller: heightController,
                          label: 'Altura (cm)',
                          prefixIcon: Icons.height,
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
                        _buildFormField(
                          controller: descriptionController,
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
                              .map((String value) => DropdownMenuItem<String>(
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
                          if (_formKey.currentState?.validate() ?? false) {
                            // TODO: Implement save logic
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
