import 'package:flutter/material.dart';

class EditPerson extends StatelessWidget {
  final String name; // TODO : CHANGE THIS WITH A Person entity
  const EditPerson({super.key, this.name = ''});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar cliente'),
        backgroundColor: theme.colorScheme.primary,
        centerTitle: true,
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (name.isNotEmpty)
            Text('Editar cliente $name',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ))
          else
            Text('Seleccione un cliente, por favor',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
        ]),
      ),
    );
  }
}
