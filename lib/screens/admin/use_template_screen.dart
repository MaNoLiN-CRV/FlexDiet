import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';

class UseTemplateScreen extends StatelessWidget {
  const UseTemplateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height * 0.8;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        title: const Text('Usar Plantillas'),
        titleTextStyle: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height,
              child: CardScroll(
                cards: [
                  CardData(
                    title: 'PLANTILLA PARA MUJERES - PERDER PESO',
                    description:
                        '2000kcal diarias, dieta para perder peso para mujeres',
                    imageUrl:
                        'https://i.pinimg.com/originals/59/0f/88/590f88779605c7bff6fba423fa2e2492.png',
                  ),
                  CardData(
                    title: 'DIETA PARA CONSTRUIR MÚSCULO',
                    description: '3500kcal diarias, dieta para ganar peso',
                    imageUrl:
                        'https://i.pinimg.com/originals/59/0f/88/590f88779605c7bff6fba423fa2e2492.png',
                  ),
                  CardData(
                    title: 'DIETA PARA ATLETAS',
                    description: '2500kcal diarias, para atletas',
                    imageUrl:
                        'https://i.pinimg.com/originals/59/0f/88/590f88779605c7bff6fba423fa2e2492.png',
                  ),
                ],
                scrollDirection: Axis.vertical,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
