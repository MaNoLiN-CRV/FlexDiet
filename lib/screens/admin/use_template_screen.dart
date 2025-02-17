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
        title: const Text('Use Templates'),
        titleTextStyle: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox( 
                height: height,
                child: CardScroll(
                  cards: [
                    CardData(
                      title: 'TEMPLATE FOR WOMEN - WEIGHT LOSS',
                      description:
                          '2000kcal diet specifically designed for women who want to lose weight in a healthy way. Includes a balanced nutritional profile and recipes focused on your goals.',
                      imageUrl:
                          'https://images.unsplash.com/photo-1607178743429-f34aa08f784d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjQwNzZ8MHwxfHNlYXJjaHwxfHxkaWV0JTIwd29tYW58ZW58MHx8fHwxNzA3NjY3NzYxfDA&ixlib=rb-4.0.3&q=80&w=200',
                    ),
                    CardData(
                      title: 'DIET FOR MUSCLE GAIN',
                      description:
                          '3500kcal meal plan optimized for muscle growth. Rich in protein and complex carbohydrates to support your workouts and muscle recovery.',
                      imageUrl:
                          'https://images.unsplash.com/photo-1556771512-9804c2c7482f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjQwNzZ8MHwxfHNlYXJjaHw2fHxidWxrJTIwbXVzY2xlfGVufDB8fHx8MTcwNzY2NzgyOXww&ixlib=rb-4.0.3&q=80&w=200',
                    ),
                    CardData(
                      title: 'DIET FOR ATHLETES',
                      description:
                          'Balanced diet of 2500kcal designed for athletes who want to maintain optimal performance. Provides the energy and nutrients needed for intense training and competition.',
                      imageUrl:
                          'https://images.unsplash.com/photo-1554999212-c68ed64f0a51?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjQwNzZ8MHwxfHNlYXJjaHwxfHNsYWxhZCUyMGF0aGxldGV8ZW58MHx8fHwxNzA3NjY3ODc3fDA&ixlib=rb-4.0.3&q=80&w=200',
                    ),
                  ],
                  scrollDirection: Axis.vertical,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

