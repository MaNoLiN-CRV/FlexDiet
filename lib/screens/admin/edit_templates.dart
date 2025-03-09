import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/models/template.dart';
import 'package:flutter_flexdiet/widgets/custom_toast.dart';

class EditTemplatesScreen extends StatefulWidget {
  final List<Template> templates;
  const EditTemplatesScreen({super.key, required this.templates});
  @override
  _EditTemplatesScreenState createState() => _EditTemplatesScreenState();
}

class _EditTemplatesScreenState extends State<EditTemplatesScreen> {
  List<Template> _templates = [];

  @override
  void initState() {
    super.initState();
    _templates = widget.templates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Plantillas'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_templates.isEmpty) {
      return Center(
        child: Text('No hay plantillas disponibles'),
      );
    }

    return ListView.builder(
      itemCount: _templates.length,
      itemBuilder: (context, index) {
        final template = _templates[index];
        return ListTile(
          title: Text(template.name),
          subtitle: Text(template.description),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _editTemplate(template);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteTemplate(template);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editTemplate(Template template) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _EditTemplateScreen(template)),
    );
    setState(() {});
  }

  void _deleteTemplate(Template template) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Eliminar Plantilla'),
          content: Text(
              '¿Estás seguro de eliminar la plantilla "${template.name}"?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                _deleteTemplateConfirm(template);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteTemplateConfirm(Template template) async {
    try {
      await Template.deleteTemplate(template.id);
      showToast(context, 'Plantilla eliminada correctamente',
          toastType: ToastType.success);
      setState(() {
        _templates.remove(template);
      });
    } catch (e) {
      showToast(context, 'Error al eliminar la plantilla',
          toastType: ToastType.error);
    }
    Navigator.pop(context);
  }
}

class _EditTemplateScreen extends StatefulWidget {
  final Template template;

  _EditTemplateScreen(this.template);

  @override
  _EditTemplateScreenState createState() => _EditTemplateScreenState();
}

class _EditTemplateScreenState extends State<_EditTemplateScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';

  @override
  void initState() {
    super.initState();
    _name = widget.template.name;
    _description = widget.template.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Plantilla'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa un nombre';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa una descripción';
                  }
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveTemplate,
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTemplate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Template template = Template(
        id: widget.template.id,
        name: _name,
        description: _description,
        dayIds: widget.template.dayIds,
        calories: widget.template.calories,
        type: widget.template.type,
      );
      Template.updateTemplate(template).then((_) {
        showToast(context, 'Plantilla actualizada correctamente',
            toastType: ToastType.success);
        Navigator.pop(context);
      }).catchError((e) {
        showToast(context, 'Error al actualizar la plantilla',
            toastType: ToastType.error);
      });
    }
  }
}
