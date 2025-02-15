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
          title: const Text('Use Template'),
          titleTextStyle: TextStyle(color: theme.iconTheme.color, fontWeight: FontWeight.bold, fontSize: 20),
          centerTitle: true,
        ),
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          height: height,
          child: CardScroll(
            cards: [
              CardData(
                title: 'WOMEN TEMPLATE LOST WEIGHT',
                description: '2000kcal daily, lost weight diet for women',
                imageUrl:
                    'https://i.pinimg.com/originals/59/0f/88/590f88779605c7bff6fba423fa2e2492.png',
              ),
              CardData(
                title: 'MUSCLE BUILDING DIET',
                description: '3500kcal daily, weight gain diet',
                imageUrl:
                    'https://i.pinimg.com/originals/59/0f/88/590f88779605c7bff6fba423fa2e2492.png',
              ),
              CardData(
                title: 'ATHELETIC DIET',
                description: '2500kcal daily, for athletes',
                imageUrl:
                    'https://i.pinimg.com/originals/59/0f/88/590f88779605c7bff6fba423fa2e2492.png',
              ),
            ],
            scrollDirection: Axis.vertical,
          ),
        ),
      ]),
    ));
  }
}
